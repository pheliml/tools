#!/usr/bin/env node

const fs = require('fs');

const projectStructure = {
	'src': ['index.js'],
	'public': ['index.html', 'styles.css']
};

Object.entries(projectStructure).forEach(([dir, files]) => {
	fs.mkdirSync(dir, { recursive: true });
	files.forEach(file => fs.writeFileSync(`${dir}/${file}`, ''));
});

console.log("Project structure created successfully!");

