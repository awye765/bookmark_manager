#Bookmark
##User stories
```
As a user,
So I can select a link of a website that I visit frequently
I would like to see a list of websites
```
```
As a user,
So I can save a website
I would like to add the website address and the title to my Book-manager
```
```
As a user,
So I can organise my links in different categories for searching
I would like to add tags to my links
```
```
As a user,
So I can quickly find the links that I need
I would like the links be filtered by tags
```
##Domain Model


Objects           | Messages
-------------     | -------------
User              | uses Bookmark manager
Bookmark manager  | shows list of links
Bookmark manager  | allows user to add links
Bookmark manager  | has tags for links
Bookmark manager  | filters by tags
