require "./utils.rb"

class TabColumn 
    # string_mapping is a hash that maps string name to fret number
    # fret number range (0 -> num_frets_of_instrument)
    def initialize(string_mapping)
        @string_mapping = string_mapping
    end
end

class Tab 
    # initialize with a chord collection
    def initialize(chords)
        @chords = chords
        # TODO figure out how to handle different sections and conserve other parts of a tab
        # such as dynamics (ie. hammer ons/bends)
    end

    # for now assume all are from guitar
    # assume everything for one 6 string guitar
    def self.construct_from_text(text)
        # TODO return a new Tab object from a single string
        lines = text.split("\n")

        # need to collect the lines into line groups that we can iterate through
        line_groups = []
        current_line_group = []
        line_group_length = 6

        lines.each do |line|
            unless !line.include?("-")
                current_line_group.append(line)

                if current_line_group.length == line_group_length
                    line_groups.append(current_line_group)
                    current_line_group = []
                end
            end
        end

        line_base_notes = [Note.from_note("E4"), Note.from_note("B3"), Note.from_note("G3"), Note.from_note("D3"), Note.from_note("A2"), Note.from_note("E2")]
        chords = ChordCollection.new()

        # need to read every 6 lines until there are none left
        line_groups.each do |line_group|
            (0...line_group[0].length).each do |index|
                potential_notes = []
                line_group.each_with_index do |line, group_num|
                    if line[index].is_number?
                        semitones_above = line[index].to_i
                        potential_notes.append(line_base_notes[group_num].get_num_semitones_above(semitones_above))
                    end
                end
                chords.add_chord(Chord.new(potential_notes))
            end
        end

        return Tab.new(chords)
    end

    # assumes we can fit an entire file in memory as a single string
    # for now assume all are from guitar
    def self.construct_from_file(filename)
        file = File.open(filename)
        text = file_data = file.read
        return self.construct_from_text(text)
    end

end

class Note 
    # maps note numbers to human readable and allows us to do operations on them
    # (optional extension) maybe handle time signatures and stuff like

    # use MIDI numbers C1 = 24, C2 = 36, C4 (middle C) = 60
    @base_note_mapping = {
        "C"=> 24, "C#"=> 25, "Db"=> 25,  "D"=> 26, "D#"=> 27, "Eb"=> 27, "E"=> 28, "F"=> 29, "F#"=> 30,
        "Gb"=> 30, "G"=> 31, "G#"=> 32, "Ab"=> 32, "A"=> 33, "A#"=> 34, "Bb"=> 34, "B"=> 35
    }

    def initialize(number)
        if number.instance_of? Integer
            @number = number
        else
            raise "Invalid Note initialization type for number #{number}"
        end
    end

    def self.from_note(note)
        letter = note[0].upcase
        is_sharp = false
        is_flat = false

        if note[1].is_number?
            octave = note[1..].to_i
        else
            # this happens if we have a sharp or flat
            letter = note[0, 2]
            octave = note[2..].to_i
        end

        # base value is based on C1 to B1
        base_value = @base_note_mapping[letter]
        midi_value = base_value + 12 * (octave - 1)

        return Note.new(midi_value)
    end

    # TODO more functions that can do math on top of the note
    def get_num_semitones_above(num_semitones)
        return Note.new(@number + num_semitones)
    end
end

class Chord 
    # represents a single note or note collection

    # notes is a list (of at least 1 note, can handle rests and stuff in the future maybe but probably inside the note)
    def initialize(notes)
        @notes = notes
    end
end

# TODO chord object, chord collection objet
class ChordCollection 

    def initialize()
        @chords = []
    end

    def add_chord(chord)
        @chords.append(chord)
    end

    def convert_to_tab(instrument)
        # TODO convert to the tab based on the instrument + tuning
    end
end


# puts Tab.construct_from_file("example.txt")
