return function(html)
html = html:gsub('<img[^>]+>', '')
return html
end
