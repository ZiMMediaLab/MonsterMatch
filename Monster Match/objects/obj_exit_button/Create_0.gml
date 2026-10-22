/// @description Hide Exit on the web
// game_end() does nothing in a browser
if (os_browser != browser_not_a_browser)
{
    instance_destroy();
}
