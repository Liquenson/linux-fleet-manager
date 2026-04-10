#!/bin/bash

set -e

echo "��� Running Local CI Tests..."
echo ""

# Test 1: ShellCheck
echo "1️⃣  Running ShellCheck..."
if command -v shellcheck &>/dev/null; then
    find scripts -name "*.sh" -type f -exec shellcheck {} \;
    find lib -name "*.sh" -type f -exec shellcheck {} \;
    echo "✅ ShellCheck passed"
else
    echo "⚠️  ShellCheck not installed, skipping"
fi
echo ""

# Test 2: Script --help
echo "2️⃣  Testing --help..."
./scripts/inventory/server-inventory.sh --help > /dev/null
echo "✅ --help works"
echo ""

# Test 3: Script --version
echo "3️⃣  Testing --version..."
./scripts/inventory/server-inventory.sh --version > /dev/null
echo "✅ --version works"
echo ""

# Test 4: CSV generation
echo "4️⃣  Testing CSV generation..."
rm -rf reports/
./scripts/inventory/server-inventory.sh --format csv > /dev/null
if [[ -f reports/server-inventory_*.csv ]]; then
    echo "✅ CSV generated successfully"
    echo "   Content:"
    cat reports/server-inventory_*.csv | head -2
else
    echo "❌ CSV not generated"
    exit 1
fi
echo ""

# Test 5: JSON generation
echo "5️⃣  Testing JSON generation..."
./scripts/inventory/server-inventory.sh --format json > /dev/null
if [[ -f reports/server-inventory_*.json ]]; then
    echo "✅ JSON generated successfully"
else
    echo "❌ JSON not generated"
    exit 1
fi
echo ""

# Test 6: Project structure
echo "6️⃣  Verifying project structure..."
missing=0
for file in README.md LICENSE CHANGELOG.md CONTRIBUTING.md; do
    if [[ ! -f "$file" ]]; then
        echo "❌ $file missing"
        missing=1
    fi
done

for dir in scripts lib config docs; do
    if [[ ! -d "$dir" ]]; then
        echo "❌ $dir/ missing"
        missing=1
    fi
done

if [[ $missing -eq 0 ]]; then
    echo "✅ Project structure valid"
else
    exit 1
fi
echo ""

echo "��� All local tests passed!"
echo "✅ Safe to commit and push"
