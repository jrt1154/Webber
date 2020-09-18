# Webber - HTML phantom

# Classes
class Page
	
	def initialize(body="",title="",css="")
		@css = css
		@charset = "utf-8"
		@favicon = "images/favicon.png"
		@lang = "en"
		@scripts = "js/scripts.js"
		@stylesheet = "css/main.css"
		@title = title
		
		@body = body
	end
	
	def generateBody(level)
		# Set Tab Level
		subLevel = level + 1
		
		# Create Tags
		scriptJS = Tag.new("script",[["src","js/scripts.js"]])
		
		# Generate Tags
		bodyContent = divTag(@body,[["id","container"]])
		
		# Create Body Tag
		body = Tag.new("body","",bodyContent)
		return body.generateTag(level)
	end
	
	def generateHead(level)
		# Set Tab Level
		subLevel = level
		
		# Create Tags
		metaCharset = Tag.new("meta",[["charset",@charset]])
		metaFormat = Tag.new("meta",[["name","format-detection"],["content","telephone=no"]])
		metaIE = Tag.new("meta",[["http-equiv","x-ua-compatible"],["content","ie=edge"]])
		metaViewport = Tag.new("meta",[["name","viewport"],["content","width=device-width, initial-scale=1"]])
		linkCSS = Tag.new("link",[["rel","stylesheet"],["href",@stylesheet]])
		linkFavicon = Tag.new("link",[["rel","icon"],["href",@favicon]])
		title = Tag.new("title","",@title)
		if @css and @css != ''
			style = styleTag(@css)
		else
			style=''
		end
		
		# Generate Tags
		headContent = ""
		headContent << metaCharset.generateTagSelfClosing("")
		headContent << metaFormat.generateTagSelfClosing("")
		headContent << metaIE.generateTagSelfClosing(generateTabs(subLevel))
		headContent << metaViewport.generateTagSelfClosing(generateTabs(subLevel))
		headContent << title.generateTagOneLine(generateTabs(subLevel))
		headContent << linkCSS.generateTagSelfClosing(generateTabs(subLevel))
		headContent << style
		headContent << linkFavicon.generateTagSelfClosing(generateTabs(subLevel))
		
		# Create Head Tag
		head = Tag.new("head","",headContent)
		return head.generateTag(level)
	end
	
	def generateHTML()
		# Set Tab Level
		subLevel = 1
		
		htmlContent = ""
		htmlContent << generateHead(subLevel)
		htmlContent << generateBody(subLevel)
		
		# Create HTML Tag
		html = Tag.new("html",[["lang",@lang]],htmlContent)
		return html.generateTag(0)
	end
	
	def generateDoctype(doctype)
		return "<!DOCTYPE #{doctype}>\r\n"
	end
	
	def generatePage()
		page = ""
		page << generateDoctype("html")
		page << generateHTML()
		
		return page
	end
end

class Declaration
	attr_reader :property, :value
	
	def initialize(property,value)
		@property = property
		@value = value
	end
	
	def generateDeclaration()
		return "#{@property}:#{@value};"
	end
end

class Rule
	attr_reader :selectors, :declarations
	
	def initialize(selectors,declarations)
		@selectors = Array.new
		@declarations = Array.new
		
		selectors.each do |row|
			@selectors << row
		end
		
		declarations.each do |row|
			@declarations << row
		end
	end
	
	def generateRule()
		output = ""
		@selectors.each do |row|
			output << row
			if row != @selectors.last
				output << ", "
			end
		end
		output << "{"
		@declarations.each do |row|
			output << row.generateDeclaration()
		end
		output << "}"
		return output
	end
end

class Tag
	attr_reader :tag, :attributes, :content
	
	def initialize(tag,attributes="",content="")
		@tag = tag
		@attributes = ""
		@content = content
		
		if attributes != ""
			attributes.each do |row|
				@attributes << generateAttributes(row[0],row[1])
			end
		end
	end
	
	def generateAttributes(attribute,value)
		return " #{attribute}='#{value}'"
	end
	
	def generateTag(level=0)
		tag = ""
		tag << generateTagStart(generateTabs(level))
		tag << generateTagContent(generateTabs(level+1))
		tag << generateTagEnd(generateTabs(level))
		return tag
	end
	
	def generateTagContent(tabs)
		return "#{tabs}#{@content}\r\n"
	end
	
	def generateTagStart(tabs)
		return "#{tabs}<#{@tag}#{@attributes}>\r\n"
	end
	
	def generateTagEnd(tabs)
		return "#{tabs}</#{@tag}>\r\n"
	end
	
	def generateTagOneLine(tabs)
		return "#{tabs}<#{@tag}#{@attributes}>#{@content}</#{@tag}>\r\n"
	end
	
	def generateTagSelfClosing(tabs)
		return "#{tabs}<#{@tag}#{@attributes} />\r\n"
	end
end

# Methods

def generateTabs(level)
	tabs = ""
	x = 0
	while x < level
		tabs << "	"
		x = x + 1
	end
	return tabs
end

def saveToFile(path,content)
	File.write(path,content)
end

# CSS Tag Shortcut Methods
def addGoogleFont(headingFont="",bodyFont="")
	content = ""
	if headingFont != ''
		content <<  cssImport("https://fonts.googleapis.com/css2?family=#{headingFont.gsub(' ','+')}")
		content << Rule.new(['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'strong'],[Declaration.new("font-family","#{headingFont}")]).generateRule()
	end
	if bodyFont != ''
		content <<  cssImport("https://fonts.googleapis.com/css2?family=#{bodyFont.gsub(' ','+')}")
		content << Rule.new(['body'],[Declaration.new("font-family","#{bodyFont}")]).generateRule()
	end
	return content
end

def cssAlignContent(value)
	return cssGeneric("align-content",value)
end

def cssAlignItems(value)
	return cssGeneric("align-items",value)
end

def cssDisplay(value)
	return cssGeneric("display",value)
end

def cssFlexDirection(value)
	return cssGeneric("flex-direction",value)
end

def cssFontSize(value)
	return cssGeneric("font-size",value)
end

def cssGeneric(property,value)
	return Declaration.new(property,value)
end

def cssImport(url)
	return "@import url('#{url}');"
end

def cssJustifyContent(value)
	return cssGeneric("justify-content",value)
end

def cssListStyle(value)
	return cssGeneric("list-style",value)
end

def cssMargin(value)
	return cssGeneric("margin",value)
end

def cssMarginBottom(value)
	return cssGeneric("margin-bottom",value)
end

def cssMarginLeft(value)
	return cssGeneric("margin-left",value)
end

def cssMarginRight(value)
	return cssGeneric("margin-right",value)
end

def cssMarginTop(value)
	return cssGeneric("margin-top",value)
end

def cssMaxWidth(value)
	return cssGeneric("max-width",value)
end

def cssMedia(declaration,rules)
	output = "@media (#{declaration}) {"
	rules.each do |rule|
		output << rule.generateRule()
	end
	output << "}"
	return output
end

def cssPadding(value)
	return cssGeneric("padding",value)
end

def cssPaddingInlineStart(value)
	return cssGeneric("padding-inline-start",value)
end

def cssPaddingBottom(value)
	return cssGeneric("padding-bottom",value)
end

def cssPaddingLeft(value)
	return cssGeneric("padding-left",value)
end

def cssPaddingRight(value)
	return cssGeneric("padding-right",value)
end

def cssPaddingTop(value)
	return cssGeneric("padding-top",value)
end

def cssTextAlign(value)
	return cssGeneric("text-align",value)
end

def cssTextTransform(value)
	return cssGeneric("text-transform",value)
end

def cssWidth(value)
	return cssGeneric("width",value)
end

def cssWordWrap(value)
	return cssGeneric("word-wrap",value)
end

# HTML Tag Shortcut Methods
def genericTag(tag,content,attributes)
	return Tag.new(tag,attributes,content)
end

def aTag(content="",attributes="")
	return genericTag("a",content,attributes).generateTagOneLine("")
end

def addressTag(content="",attributes="")
	return genericTag("address",content,attributes).generateTag()
end

def brTag(content="",attributes="")
	return genericTag("br",content,attributes).generateTagSelfClosing("")
end

def divTag(content="",attributes="")
	return genericTag("div",content,attributes).generateTag()
end

def footerTag(content="",attributes="")
	return genericTag("footer",content,attributes).generateTag()
end

def headerTag(content="",attributes="")
	return genericTag("header",content,attributes).generateTag()
end

def h1Tag(content="",attributes="")
	return genericTag("h1",content,attributes).generateTagOneLine("")
end

def h2Tag(content="",attributes="")
	return genericTag("h2",content,attributes).generateTagOneLine("")
end

def h3Tag(content="",attributes="")
	return genericTag("h3",content,attributes).generateTagOneLine("")
end

def h4Tag(content="",attributes="")
	return genericTag("h4",content,attributes).generateTagOneLine("")
end

def h5Tag(content="",attributes="")
	return genericTag("h5",content,attributes).generateTagOneLine("")
end

def h6Tag(content="",attributes="")
	return genericTag("h6",content,attributes).generateTagOneLine("")
end

def hrTag(content="",attributes="")
	return genericTag("hr",content,attributes).generateTagSelfClosing("")
end

def liTag(content="",attributes="")
	return genericTag("li",content,attributes).generateTagOneLine("")
end

def mainTag(content="",attributes="")
	return genericTag("main",content,attributes).generateTag()
end

def olTag(content="",attributes="")
	return genericTag("ol",content,attributes).generateTag()
end

def pTag(content="",attributes="")
	output = ""
	content.split(/\n+/).each do |line|
		para = Tag.new("p",attributes,line)
		output << para.generateTagOneLine("")
	end
	
	return output
end

def sectionTag(content="",attributes="")
	return genericTag("section",content,attributes).generateTag()
end

def spanTag(content="",attributes="")
	return genericTag("span",content,attributes).generateTagOneLine("")
end

def strongTag(content="",attributes="")
	return genericTag("strong",content,attributes).generateTagOneLine("")
end

def styleTag(content="",attributes="")
	return genericTag("style",content,attributes).generateTag()
end

def timeTag(content="",attributes="")
	return genericTag("time",content,attributes).generateTagOneLine("")
end

def ulTag(content="",attributes="")
	return genericTag("ul",content,attributes).generateTag()
end

# Other shortcuts
def orderedList(content="",attributes="")
	output = ""
	content.each do |row|
		output << liTag(row)
	end
	return olTag(output)
end

def unorderedList(content="",attributes="")
	output = ""
	content.each do |row|
		output << liTag(row)
	end
	return ulTag(output)
end