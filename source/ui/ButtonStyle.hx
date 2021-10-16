package ui;

enum ButtonStyle
{
    Ok;
    Yes_No;
    Custom(yes:Bool, no:Bool);
    None;
}