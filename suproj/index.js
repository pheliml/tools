#!/usr/bin/env node
const fs = require('fs');
const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')
const argv = yargs(hideBin(process.argv)).argv

let projectStructure = {}

function createJsProj(projectStructure) {

	if (argv.src)
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


	console.log("Javascript project structure created successfully!");
}

function createGoProj(projectStructure) {

	if (argv.src && argv.src != "main")
	{
		console.log("override with main file");
	}

	projectStructure = {
		'cmd': ['main.go'], //cmd instead of src
		'internal': ['app.go'], //files in internal dirs are private
		'pkg': ['public.go'], //files in pkg dirs are public
		'test': ['main_test.go'], //test file for the main application
		'scripts': ['script.go']
		}
	
	Object.entries(projectStructure).forEach(([dir, files]) => {
	fs.mkdirSync(dir, { recursive: true });
	files.forEach(file => fs.writeFileSync(`${dir}/${file}`, ''));
	});

	console.log("Go project structure created successfully!");
}

if (argv.lang)
{
	switch (argv.lang)
	{
		case "js":
			createJsProj(projectStructure)
			break;
		case "go":
			createGoProj(projectStructure)
			break;
		default:
			break;
	}
} else {
	console.log("argument --lang required");
}
	
