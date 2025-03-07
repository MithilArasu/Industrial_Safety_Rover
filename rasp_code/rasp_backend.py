from flask import Flask, request, jsonify
from time import sleep
import RPi.GPIO as GPIO

app = Flask(_name_)

# Define Motor Pins
MOTORS = {
    "M1": {"IN1": 24, "IN2": 23, "EN": 25},  # Front Left
    "M2": {"IN1": 17, "IN2": 27, "EN": 22},  # Front Right
    "M3": {"IN1": 0, "IN2": 5, "EN": 6},     # Back Left
    "M4": {"IN1": 1, "IN2": 12, "EN": 16},   # Back Right
}

GPIO.setmode(GPIO.BCM)

# Setup pins
for motor in MOTORS.values():
    GPIO.setup(motor["IN1"], GPIO.OUT)
    GPIO.setup(motor["IN2"], GPIO.OUT)
    GPIO.setup(motor["EN"], GPIO.OUT)
    GPIO.output(motor["IN1"], GPIO.LOW)
    GPIO.output(motor["IN2"], GPIO.LOW)

# Create PWM objects for speed control
PWM = {name: GPIO.PWM(motor["EN"], 1000) for name, motor in MOTORS.items()}

# Start PWM at 100% speed
for pwm in PWM.values():
    pwm.start(100)

# Motor control functions
def forward():
    print("Moving Forward")
    for motor in MOTORS.values():
        GPIO.output(motor["IN1"], GPIO.HIGH)
        GPIO.output(motor["IN2"], GPIO.LOW)

def stop():
    print("Stopping Motors")
    for motor in MOTORS.values():
        GPIO.output(motor["IN1"], GPIO.LOW)
        GPIO.output(motor["IN2"], GPIO.LOW)

def turn_left():
    print("Turning Left")
    GPIO.output(MOTORS["M1"]["IN1"], GPIO.LOW)
    GPIO.output(MOTORS["M1"]["IN2"], GPIO.HIGH)
    GPIO.output(MOTORS["M2"]["IN1"], GPIO.HIGH)
    GPIO.output(MOTORS["M2"]["IN2"], GPIO.LOW)

def turn_right():
    print("Turning Right")
    GPIO.output(MOTORS["M1"]["IN1"], GPIO.HIGH)
    GPIO.output(MOTORS["M1"]["IN2"], GPIO.LOW)
    GPIO.output(MOTORS["M2"]["IN1"], GPIO.LOW)
    GPIO.output(MOTORS["M2"]["IN2"], GPIO.HIGH)

def cleanup():
    print("Cleaning up GPIO...")
    for pwm in PWM.values():
        pwm.stop()
    GPIO.cleanup()

# Initialize rover parameters
length = 0
breadth = 0
running = 0  # Default status
speed = 2  # m/s

@app.route('/rover', methods=['POST'])
def add_rover():
    global length, breadth, running
    data = request.json

    if not data or "length" not in data or "breadth" not in data:
        return jsonify({"error": "Missing length or breadth"}), 400

    length = data["length"]
    breadth = data["breadth"]
    running = 1 if length != 0 and breadth != 0 else 0

    if running:
        execute_movement(int(length),int( breadth))
    return jsonify({
        "message": "Rover data updated successfully",
        "length": length,
        "breadth": breadth,
        "running": running
    }), 201

def execute_movement(length, breadth):
    segment_length = length / 3
    time_per_segment = segment_length / speed

    for _ in range(3):
        stop()
        forward()
        stop()
        sleep(time_per_segment)
        stop()
        sleep(3)

        turn_left()
        sleep(1)
        stop()

        breadth_segment = breadth / 3
        time_per_breadth = breadth_segment / speed
        forward()
        sleep(time_per_breadth)
        stop()
        turn_right()
        sleep(1)
        stop()

@app.route('/running_or_not', methods=['GET'])
def get_running_status():
    return jsonify({"running": running}), 200

if _name_ == '_main_':
    try:
        app.run(host="0.0.0.0", port=5000, debug=True)
    except KeyboardInterrupt:
        print("Shutting down gracefully...")
        cleanup()