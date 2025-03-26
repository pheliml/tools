#!/usr/bin/env node
const fs = require('fs');
const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')
const argv = yargs(hideBin(process.argv)).argv

let projectStructure = {}

if(argv.src)
{
	projectStructure = {
		'src': [`${argv.src}.js`],
		'public': ['index.html', 'styles.css']
	}
} else {

	projectStructure = {
		'src': ['index.js'],
		'public': ['index.html', 'styles.css']
	}
}

Object.entries(projectStructure).forEach(([dir, files]) => {
fs.mkdirSync(dir, { recursive: true });
files.forEach(file => fs.writeFileSync(`${dir}/${file}`, ''));
});


console.log("Project structure created successfully!");

