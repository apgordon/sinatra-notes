require 'sinatra' 
require 'sinatra/reloader' 
require 'redcarpet'
require 'date'
require 'yaml'
require 'psych'

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

get "/" do
    redirect "/notes"
end

get "/notes" do 
    @titles = YAML.load_file("./files/notes.yml")
    erb :notes
end

get "/notes/new" do 
   erb :note_new 
end

post "/notes/new" do
    @note = params["note"]
    @title = params["title"]
    
    # save note in /views
    @now = DateTime.now-(5/24.0)
    @filename = @now.strftime("%Y-%m-%d-%k-%M-%S")
    File.write("./files/" + @filename + ".md", @note)
    
    # append filename:title key-value pair to notes.yml
    File.open('./files/notes.yml', 'a') { |text| 
        text.puts "\n#{@filename}: #{@title}" } 
    redirect "/notes"
end

get "/notes/:filename" do
    file = "./files/#{params["filename"]}.md"
    text = IO.read(file)
    @titles = Psych.load_file("./files/notes.yml")
    @title = @titles[params["filename"]]
    @md = markdown.render(text)
    erb :note
end

get "/notes/:filename/edit" do
    file = "./files/#{params["filename"]}.md"
    @text = IO.read(file)
    @titles = Psych.load_file("./files/notes.yml")
    @title = @titles[params["filename"]]
    erb :note_edit
end

