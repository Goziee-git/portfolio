from django.shortcuts import render

def home(request):
    return render(request, 'portfolio/home.html')

def about(request):
    return render(request, 'portfolio/about.html')

def projects(request):
    projects = [
        {'name': 'Project 1', 'description': 'Web application built with Django'},
        {'name': 'Project 2', 'description': 'API service with REST framework'},
        {'name': 'Project 3', 'description': 'Data analysis with Python'},
    ]
    return render(request, 'portfolio/projects.html', {'projects': projects})

def contact(request):
    return render(request, 'portfolio/contact.html')
