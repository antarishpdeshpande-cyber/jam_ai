import os

file_path = "acestep/api_server.py"
with open(file_path, "r") as f:
    content = f.read()

if "CORSMiddleware" not in content:
    # Add import
    content = content.replace("from fastapi import FastAPI, Request, HTTPException, BackgroundTasks, Header, Depends", 
                              "from fastapi import FastAPI, Request, HTTPException, BackgroundTasks, Header, Depends\nfrom fastapi.middleware.cors import CORSMiddleware")
    
    # Add middleware
    content = content.replace('app = FastAPI(title="ACE-Step API", version="1.0.0")', 
                              'app = FastAPI(title="ACE-Step API", version="1.0.0")\n    app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])')
    
    with open(file_path, "w") as f:
        f.write(content)
    print("Patched api_server.py for CORS")
else:
    print("Already patched")
