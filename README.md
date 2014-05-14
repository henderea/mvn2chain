# mvn2chain

A command line tool that makes it easy to chain `mvn2` calls.  Register your dependencies with the `mvn2chain dep` commands and run them with the `mvn2chain exec` command.  See `mvn2chain help`, `mvn2chain help dep`, and `mvn2chain help exec` for more information.  Some commands have aliases.

## Installation

Install it yourself as:

    $ gem install mvn2chain

## Usage

###Add your dependencies
1. Change to the root directory of a maven project with a dependency you want to be able chain.
2. Use the `mvn2chain dep add <id> <path>` command to add the dependency to the registry.  The `<id>` parameter is the short identifier for the dependency.  You use this for referencing the dependency in `mvn2chain exec` calls, as well as for removing a dependency from the registry.  The `<path>` parameter is the path to the root directory of the maven project for the dependency.
3. To see the dependencies you already have in the registry, use `mvn2chain dep list`.
4. If you want to remove a dependency, use the `mvn2chain dep remove <id>` command, where `<id>` is the id you gave the dependency when you added it.
5. There is no limit to how many levels of dependencies you can have, and no check (at least currently) for recursive dependencies (so be careful)

###Run a chained build
The `mvn2chain exec` command will allow you to build dependency projects and then the current project.  It uses a special parameter syntax to allow you to specify `mvn2` parameters to the current project and any dependency projects (direct or indirect).

####Example
Let's say you have your project set up with dependencies `dep1` and `dep2`, and that `dep1` has the dependency `dep3`.  If you want to build the project with `mvn2` parameter `-s`, dependency `dep1`with parameter `-e`, indirect dependency `dep3` with parameter `-0`, and skip dependency `dep2`, you would do the following:

	mvn2chain exec -s +dep1 -e +dep3 -0 ~dep2
Here's the explanation:

1. You start off with all arguments being passed to the `mvn2` call for the current project, which is the `-s` argument in this case
2. Once you specify `+dep1`, you switch to specifying arguments for the `mvn2` call for `dep1`.  This is because any argument starting with `+` will switch to specifying arguments for the dependency with the id taken from the rest of the characters in the argument with the `+`.
3. Now that you've switched to specifying arguments for `dep1`, `-e` will be given to that.
4. `dep3` isn't a dependency the current project knows about, but that doesn't matter because it chains by switching to the directory of the dependency and calling `mvn2chain exec` with the arguments given for the dependency *and* the extra arguments for other dependencies (plus excluded dependencies).  In this case, that means it switches to the directory for `dep1` and calls `mvn2chain exec -e +dep3 -0 ~dep2` before switching back and running `mvn2 -s` in the current project
5. When it calls `mvn2chain exec` for the dependency, it will chain again with any dependencies that dependency has in the exact same fashion.  In this example, that means it switches to the directory of `dep1` dependency `dep3` and calls `mvn2chain exec -0 ~dep2`
6. Since `dep3` doesn't have any dependencies of its own, it will just run `mvn2 -0` and unwind back `dep1`.  If `dep1` had other dependencies, it would continue cycling through them and doing the same thing
7. Once it has gone through all of the dependencies that are not excluded, `dep1` will run its `mvn2 -e` call and unwind back to the first project
8. The first project has the dependency `dep2`, but the arguments you provided include `~dep2`.  Any argument starting with `~` will cause the dependency with the id taken from the rest of the characters in the argument with the `~` to be skipped.  You can exclude indirect dependencies in the same way because exclusions are always passed along to the chained builds.  BTW, an argument starting with `~/` will probably not be counted as an exclusion since it will probably be transformed to the absolute path of your home directory by bash before being passed to `mvn2chain`.
9. Now that all of its dependencies are build, the initial project will run `mvn2 -s` and finish the process.

## Contributing

1. Fork it ( https://github.com/henderea/mvn2chain/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
