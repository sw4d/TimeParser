# © Stephen Ford 2019 all rights reserved. Written with Ruby 2.6.2

# Without using any built-in date or time functions, write a function or method that accepts two
# mandatory arguments: the first argument is a 12-hour time string with the format "[H]H:MM
# {AM|PM}", and the second argument is a (signed) integer. The second argument is the number of
# minutes to add to the time of day represented by the first argument. The return value should be a
# string of the same format as the first argument. For example, AddMinutes("9:13 AM", 200) would
# return "12:33 PM".

############################################################
# In the event none of Ruby's Time libraries aren't available
# this method can be utilized to add minutes to a given time
############################################################

def add_minutes(time, additional_minutes)
  basic_type_check(time, additional_minutes)
  new_time = AppendTimeToSet.new(ParsedTime.new(time), additional_minutes)
  "#{new_time.hour}:#{format('%02d', new_time.minute)} #{new_time.period}"
end

private

############################################################
# This is probably overkill, but I wanted some kind of +1
# that I was trying to consider what environment this method
# might be running in.
############################################################

def basic_type_check(time, minutes)
  raise 'Unexpected type passed for time variable - should be string' unless time.is_a? String
  raise 'Unexpected type passed for additional_minutes variable - should be integer' unless minutes.is_a? Integer
end

class AppendTimeToSet
  def initialize(base_time, additional_mins)
    time_to_add = TimeToAdd.new(base_time.minute, additional_mins)
    hour_to_add = base_time.hour
    period = base_time.period

    (1..time_to_add.hours).each do |_|
      hour_to_add += 1
      if hour_to_add >= 12
        hour_to_add = 1 if hour_to_add > 12
        period = flip_period[period.to_sym]
      end
    end

    @hour = hour_to_add
    @minute = time_to_add.minutes
    @period = period
  end

  def hour
    @hour
  end

  def minute
    @minute
  end

  def period
    @period
  end
end

############################################################
# Called when enough hours have been added to a given txime
# that we need to switch our time from am/pm
############################################################

def flip_period
  { AM: 'PM', PM: 'AM' }
end

class TimeToAdd
  def initialize(base_minutes, additional_minutes)
    if additional_minutes.zero?
      @add_hours = 0
    else
      @add_hours = (0..additional_minutes).step(60).size - 1 
      @add_hours += 1 if base_minutes + (additional_minutes % 60) >= 60
    end

      @additional_minutes = (base_minutes + additional_minutes) % 60
  end

  def hours
    @add_hours
  end

  def minutes
    @additional_minutes
  end
end

class ParsedTime
  def initialize(time)
    @time_period = time.split(' ')[1]
    @time_split_hour_minute = time.split('_')[0].split(':')
  end

  def period
    @time_period
  end

  def minute
    @time_split_hour_minute[1].to_i
  end

  def hour
    @time_split_hour_minute[0].to_i
  end
end
