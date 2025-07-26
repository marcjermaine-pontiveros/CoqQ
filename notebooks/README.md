# Jupyter Notebooks for CoqQ Rocq Development

This directory contains Jupyter notebooks for interactive development and exploration of the CoqQ quantum formalization project.

## 🚀 Getting Started

1. **Access Jupyter Lab**: Go to http://localhost/jupyter/
2. **Navigate to notebooks**: Open the `notebooks/` folder
3. **Create new notebooks**: Use the "+" button to create new Python or text notebooks
4. **Run Rocq commands**: Use shell commands in code cells with `!rocq command`

## 📋 Available Notebooks

### Example Notebooks
- **Welcome.ipynb**: Introduction to the Jupyter environment
- **Rocq_Basics.ipynb**: Basic Rocq concepts and CoqQ exploration
- **Quantum_Examples.ipynb**: Quantum computing examples using CoqQ

## 🔧 Using Rocq in Jupyter

### Shell Commands
```python
# Check Rocq version
!rocq --version

# Build the project
!dune build

# Compile a specific file
!rocq compile /home/opam/workspace/src/quantum.v

# List project files
!ls /home/opam/workspace/src/
```

### Python Integration
```python
import os
import subprocess

# Change to project directory
os.chdir('/home/opam/workspace')

# Run Rocq commands
result = subprocess.run(['rocq', '--version'], capture_output=True, text=True)
print(result.stdout)
```

### File Exploration
```python
# Read Rocq source files
with open('/home/opam/workspace/src/quantum.v', 'r') as f:
    content = f.read()
    print(content[:500])  # First 500 characters
```

## 📚 Educational Use Cases

### 1. **Interactive Documentation**
- Document your proofs with markdown cells
- Mix code, mathematics, and explanations
- Create tutorials for quantum formalization concepts

### 2. **Proof Development**
- Prototype proof ideas in notebooks
- Test small examples before adding to main files
- Share proof sketches with collaborators

### 3. **Project Analysis**
- Analyze project structure and dependencies
- Generate statistics about the codebase
- Create visual representations of proof dependencies

### 4. **Learning and Teaching**
- Step-by-step proof explanations
- Interactive exercises
- Quantum computing concept illustrations

## 🛠️ Development Workflow

### Typical Workflow
1. **Explore**: Browse existing `.v` files in notebooks
2. **Prototype**: Test new ideas with shell commands
3. **Document**: Create markdown cells explaining concepts
4. **Develop**: Move to Web IDE for serious development
5. **Share**: Export notebooks for collaboration

### Best Practices
- Use descriptive notebook names
- Include markdown explanations
- Save regularly (notebooks are persistent)
- Use version control for important notebooks

## 🔗 Integration with Other Tools

### Web IDE Integration
- Use Jupyter for exploration and documentation
- Switch to Web IDE (`http://localhost/ide/`) for intensive development
- Both share the same file system

### Documentation Generation
- Notebooks can supplement auto-generated docs
- Export to HTML/PDF for sharing
- Include in project documentation

## 📊 Example Use Cases

### Proof Statistics
```python
import glob
import re

# Count theorems and lemmas
v_files = glob.glob('/home/opam/workspace/src/*.v')
theorem_count = 0
lemma_count = 0

for file in v_files:
    with open(file, 'r') as f:
        content = f.read()
        theorem_count += len(re.findall(r'Theorem\s+\w+', content))
        lemma_count += len(re.findall(r'Lemma\s+\w+', content))

print(f"Found {theorem_count} theorems and {lemma_count} lemmas")
```

### Dependency Analysis
```python
# Analyze imports and dependencies
import_pattern = r'(?:From|Require)\s+Import\s+([^.]+)'
dependencies = set()

for file in v_files:
    with open(file, 'r') as f:
        content = f.read()
        deps = re.findall(import_pattern, content)
        dependencies.update(deps)

print("Project dependencies:")
for dep in sorted(dependencies):
    print(f"  - {dep}")
```

## 🎯 Tips for Effective Use

1. **Keep notebooks focused**: One concept per notebook
2. **Use descriptive titles**: Make notebooks self-explanatory
3. **Include context**: Explain what each code cell does
4. **Test regularly**: Run cells to ensure they work
5. **Save often**: Jupyter auto-saves but manual saves are safer

## 🆘 Troubleshooting

### Common Issues
- **Command not found**: Make sure you're in the right directory
- **Permission errors**: Files should be accessible to `opam` user
- **Build failures**: Check that dependencies are installed

### Getting Help
- Use `!rocq --help` for Rocq command help
- Check logs with `make logs-jupyter`
- Access the main container with `make shell`

---

**Happy Interactive Development! 📊🔬**

For more advanced development, switch to the Web IDE at http://localhost/ide/