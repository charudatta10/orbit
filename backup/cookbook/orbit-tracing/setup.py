#!/usr/bin/env python3
"""
Setup script for orbit Tracing cookbook.

This script helps install dependencies and verify the setup.
"""

import subprocess
import sys
import os


def install_dependencies():
    """Install required dependencies."""
    print("📦 Installing dependencies...")
    try:
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", "-r", "requirements.txt"]
        )
        print("✅ Dependencies installed successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        return False


def verify_setup():
    """Verify that the setup is working."""
    print("🔍 Verifying setup...")
    try:
        # Try to import the tracing module
        from tracing import trace_flow, TracingConfig

        print("✅ Tracing module imported successfully!")

        # Try to load configuration
        config = TracingConfig.from_env()
        if config.validate():
            print("✅ Configuration is valid!")
        else:
            print("⚠️ Configuration validation failed - check your .env file")

        return True
    except ImportError as e:
        print(f"❌ Failed to import tracing module: {e}")
        return False
    except Exception as e:
        print(f"❌ Setup verification failed: {e}")
        return False


def main():
    """Main setup function."""
    print("🚀 orbit Tracing Setup")
    print("=" * 40)

    # Check if we're in the right directory
    if not os.path.exists("requirements.txt"):
        print(
            "❌ requirements.txt not found. Please run this script from the orbit-tracing directory."
        )
        sys.exit(1)

    # Install dependencies
    if not install_dependencies():
        sys.exit(1)

    # Verify setup
    if not verify_setup():
        sys.exit(1)

    print("\n🎉 Setup completed successfully!")
    print("\n📚 Next steps:")
    print("1. Check the README.md for usage instructions")
    print("2. Run the examples: python examples/basic_example.py")
    print("3. Run the test suite: python test_tracing.py")
    print("4. Check your Langfuse dashboard (URL configured in LANGFUSE_HOST)")


if __name__ == "__main__":
    main()

