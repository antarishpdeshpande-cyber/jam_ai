import os

file_path = os.path.expanduser("~/ACE-Step-1.5/acestep/api_server.py")
with open(file_path, "r") as f:
    content = f.read()

if "CORSMiddleware" not in content:
    print("Patching CORS...")
    # Add import
    content = content.replace("from fastapi import FastAPI", 
                              "from fastapi.middleware.cors import CORSMiddleware\nfrom fastapi import FastAPI")
    
    # Add middleware
    target = 'app = FastAPI(title="ACE-Step API", version="1.0", lifespan=lifespan)'
    replacement = 'app = FastAPI(title="ACE-Step API", version="1.0", lifespan=lifespan)\n    app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])'
    
    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, "w") as f:
            f.write(content)
        print("SUCCESS: Patched api_server.py")
    else:
        print(f"ERROR: Could not find FastAPI init line. Search target: '{target}'")
else:
    print("ALREADY PATCHED: CORSMiddleware found")

# Verify
with open(file_path, "r") as f:
    new_content = f.read()
    if "CORSMiddleware" in new_content:
        print("VERIFIED: File contains CORSMiddleware")
    else:
        print("FAILED: File does not contain CORSMiddleware")
