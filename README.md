# Nairaland top liked posts per thread

The rationale for this is to develop a working way to quickly scour through the thousands of posts per thread on each [Nairaland](https://www.nairaland.com) thread, and sift out the posts with the highest number of "likes", which is actually the most efficient way of determining the posts that resonated with the readers most.
I was tired of reading through hundreds of pages on each thread to get to the important stuff, so I wanted a way to cut to the chase.

- In theory, the code should work on any [Nairaland](https://www.nairaland.com) thread. I test ran it on [this](https://www.nairaland.com/5031893/canadian-express-entry-federal-skilled) and [that](https://www.nairaland.com/5042902/general-german-student-visa-enquiries/211) thread and it works just fine
- Code is written in [ruby](https://github.com/ruby/ruby). Gems used include [Nokogiri](https://nokogiri.org/) and [Httparty](https://www.rubydoc.info/gems/httparty/0.16.4)
- You can run on the commandline on a ruby environment
- The scrapped result is written to PDF using [Prawn](https://github.com/prawnpdf).
- You can clone the repo and make any further modifications you deem fit to the code.
