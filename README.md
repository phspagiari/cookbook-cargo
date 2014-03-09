cargo Cookbook
==============
This cookbook will bootstrap and configure cargo in your environment.


Requirements
------------
This cookbook depends the default opscode resources:
 - apt (http://github.com/opscode/apt)

Attributes
----------


Usage
-----
```json
{
  "cargo": {
    "aws_access_key":"",
    "aws_secret_key":"",
    "bucket":"",
    "base_domain":"",
  },
  "run_list": [
    "recipe[cargo]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `feature/add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: 
- Pedro H. Spagiari (phspagiari@gmail.com) github.com/phspagiari
- Rodrigo Chacon (rochacon@gmail.com) github.com/rochacon
