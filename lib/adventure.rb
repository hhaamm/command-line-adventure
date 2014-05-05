# Ugly stuff for get colored output.. don't this monkey patching at home!
# This can be done with colorized gem, but I don't like dependencies for small programs
class String
def black;          "\033[30m#{self}\033[0m" end
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
def  brown;         "\033[33m#{self}\033[0m" end
def blue;           "\033[34m#{self}\033[0m" end
def magenta;        "\033[35m#{self}\033[0m" end
def cyan;           "\033[36m#{self}\033[0m" end
def gray;           "\033[37m#{self}\033[0m" end
def bg_black;       "\033[40m#{self}\0330m"  end
def bg_red;         "\033[41m#{self}\033[0m" end
def bg_green;       "\033[42m#{self}\033[0m" end
def bg_brown;       "\033[43m#{self}\033[0m" end
def bg_blue;        "\033[44m#{self}\033[0m" end
def bg_magenta;     "\033[45m#{self}\033[0m" end
def bg_cyan;        "\033[46m#{self}\033[0m" end
def bg_gray;        "\033[47m#{self}\033[0m" end
def bold;           "\033[1m#{self}\033[22m" end
def reverse_color;  "\033[7m#{self}\033[27m" end
end

module AdventureEngine
  # Builds an adventure
  def self.build(name, &block)
    adventure = Adventure.new name
    adventure.instance_eval(&block)
    return adventure
  end

  class Adventure
    def initialize(name)
      @name = name
      @dialogs = []
    end

    def start(dialog_id)
      puts "Welcome to "+@name
      next_dialog = dialog_id
      vars = {} #Shared values between dialogs..
      while(next_dialog = run_dialog(next_dialog, vars)) do
      end
    end

    # crazy DSL methods

    def dialog(dialog_id, text, &block)
      dialog = Dialog.new(dialog_id, text)
      dialog.instance_eval(&block)
      @dialogs.push dialog
    end

    def get(dialog_id)
      @dialogs.each do |dialog|
        if dialog.id == dialog_id
          return dialog
        end
      end
      nil
    end

    # Returns next dialog. If it's nil, there's no next dialog.. game over.
    def run_dialog(dialog_id, hash)
      dialog = self.get(dialog_id)
      puts dialog.text

      if dialog.game_over?
        puts "Game Over, Son".red
        return nil
      end
      
      dialog.answers.each_index do |i|
        puts ((i+1).to_s + ") " + dialog.answers[i].text).green
      end

      puts "Choose your answer carefully, son: "
      # Validating answer.. must be a number!
      # Old fashion programming.. this is highschool stuff!
      answer_id = nil
      while answer_id == nil
        answer_id = gets.to_i
        answer_id -= 1
        puts answer_id
        if answer_id < 0 or answer_id >= dialog.answers.size
          puts "Whoaa, invalid input, boy: "
          answer_id = nil
        end
      end

      # Returns next dialog id
      dialog.next(answer_id)
    end
  end

  class Dialog
    attr_reader :id, :text, :answers, :next_dialog_id

    def initialize(id, text)
      @id = id
      @text = text
      @answers = []
      @next_dialog_id = nil
      @game_over = false
    end

    # crazy DSL stuff
    def answer(next_dialog_id, text)
      answer = Answer.new(text, next_dialog_id)
      @answers.push answer
    end

    def next(answer_index)
      next_dialog_id = nil
      @answers.each_index do |i|
        if i == answer_index
          return @answers[i].next_dialog_id
        end
      end
      next_dialog_id
    end

    def game_over!
      @game_over = true
    end

    def game_over?
      @game_over
    end
  end

  class Answer
    attr_reader :text, :next_dialog_id
    def initialize(text, next_dialog_id)
      @text = text
      @next_dialog_id = next_dialog_id
    end
  end
end
