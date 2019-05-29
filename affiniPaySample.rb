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
  new_time = append_times(hashify_time(time), additional_minutes)
  "#{new_time[:hour]}:#{format('%02d', new_time[:minute])} #{new_time[:period]}"
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

############################################################
# when initially stepping into this method the time variable
# will look  something like: 'HH:MM {AM:PM}'.
#
# This method breaks that string into a hash so it's
# easier to work with down the road.
############################################################

def hashify_time(time)
  split_time = time.split('_')[0].split(':')

  {
    minute: split_time[1].to_i,
    hour: split_time[0].to_i,
    period: time.split(' ')[1]
  }
end

############################################################
# To combine times we first parse our additional_minutes
# into a format similar to the base_time hash.

# Variable, 'time_to_add' is a hash with the number of hours
# and minutes we need to add to our base_time. We append
# every new hour and flip the time period as needed.
############################################################

def append_times(base_time, additional_mins)
  time_to_add = parse_minutes_to_time_hash(base_time[:minute], additional_mins)
  (1..time_to_add[:hours]).each do |_|
    base_time[:hour] += 1
    if base_time[:hour] >= 12
      base_time[:hour] = 1 if base_time[:hour] > 12
      base_time[:period] = flip_period[base_time[:period].to_sym]
    end
  end

  {
    hour: base_time[:hour],
    minute: time_to_add[:minutes],
    period: base_time[:period]
  }
end

############################################################
# Called when enough hours have been added to a given txime
# that we need to switch our time from am/pm
############################################################

def flip_period
  { AM: 'PM', PM: 'AM' }
end

############################################################
# This method takes an integer of minutes and returns a hash
# of the total number of hours that can be parsed from them.
# The remaining minutes are returned as well.
############################################################

def parse_minutes_to_time_hash(base_minutes, additional_minutes)
  return { hours: 0, minutes: base_minutes } if additional_minutes.zero?

  add_hours = (0..additional_minutes).step(60).size - 1
  add_hours += 1 if base_minutes + (additional_minutes % 60) >= 60
  additional_minutes = (base_minutes + additional_minutes) % 60

  { hours: add_hours, minutes: additional_minutes }
end
