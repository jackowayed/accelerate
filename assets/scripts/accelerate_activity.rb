require 'ruboto.rb'

ruboto_import_widgets :TextView

java_import "android.content.Context"
java_import "android.hardware.SensorManager"
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"
java_import "android.hardware.Sensor"
ruboto_import "com.danieljackoway.accelerate.AccelerometerEventListener"

$activity.handle_create do |bundle|
  setTitle 'Shake to Change Color'

  @sensors = getSystemService Context::SENSOR_SERVICE
  accelerometers = @sensors.getSensorList(Sensor::TYPE_ACCELEROMETER)
  unless accelerometers.empty?
    @accelerometer = accelerometers[0]
  end
  @sensor = AccelerometerEventListener.new

  @sensor.handle_sensor_changed do |sensor_event|
    vals = sensor_event.values
    if Math.sqrt(vals[0] ** 2 + vals[1] ** 2 + vals[2] ** 2) > 12
      getWindow.setBackgroundDrawable ColorDrawable.new(Color.rgb(rand(255), rand(255), rand(255)))
    end
  end

  setup_content do
    text_view :text => "shake!"
  end

  handle_pause do
    @sensors.unregisterListener @sensor, @accelerometer if @accelerometer
  end

  handle_resume do
    @sensors.registerListener @sensor, @accelerometer, SensorManager::SENSOR_DELAY_UI if @accelerometer
  end
end
