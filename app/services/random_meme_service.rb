class RandomMemeService
  def self.roll
    YAML.load_file("#{Rails.root}/config/memes.yml")['memes'].sample
  end
end
