//
//  PropertyInspectorTemplateCollectionView.m
//  CocosBuilder
//
//  Created by Viktor on 7/29/13.
//
//

#import "PropertyInspectorTemplateCollectionView.h"
#import "CCBColorView.h"
#import "PropertyInspectorTemplate.h"
#import "CocosBuilderAppDelegate.h"
#import "PropertyInspectorHandler.h"

@implementation PropertyInspectorTemplateCollectionView

- (NSCollectionViewItem*) newItemForRepresentedObject:(id)object
{
    PropertyInspectorTemplate* templ = object;
    
    NSCollectionViewItem* item = [super newItemForRepresentedObject:object];
    NSView* view = item.view;
    
    NSTextField* lblName = [view viewWithTag:2];
    NSImageView* imgPreview = [view viewWithTag:1];
    
    lblName.stringValue = templ.name;
    imgPreview.image = templ.image;
    
    // Create background view
    CCBColorView* bg = [[[CCBColorView alloc] initWithFrame:NSMakeRect(2, view.bounds.size.height - view.bounds.size.width + 2, view.bounds.size.width - 4, view.bounds.size.width - 4)] autorelease];
    bg.backgroundColor = templ.color;
    bg.radius = 5;
    
    [view addSubview:bg positioned:NSWindowBelow relativeTo:NULL];
    
    return item;
}

- (NSFocusRingType) focusRingType
{
    return NSFocusRingTypeNone;
}

- (void) setSelectionIndexes:(NSIndexSet *)indexes
{
    // Reset all items
    for (int i = 0; i < [self content].count; i++)
    {
        NSCollectionViewItem* item = [self itemAtIndex:i];
        
        NSView* view = item.view;
        CCBColorView* bg = [[view subviews] objectAtIndex:0];
        bg.borderColor = NULL;
    }
    
    // Select the current item
    if (indexes.count)
    {
        NSCollectionViewItem* item = [self itemAtIndex:[indexes firstIndex]];
        
        NSView* view = item.view;
        CCBColorView* bg = [[view subviews] objectAtIndex:0];
        
        bg.borderColor = [NSColor colorWithCalibratedRed:0.47 green:0.75 blue:1 alpha:1];
    }
    
    [super setSelectionIndexes:indexes];
}

- (void) keyDown:(NSEvent *)theEvent
{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter)
    {
        if([self selectionIndexes].count == 0)
        {
            NSBeep();
            return;
        }
        
        // Confirm remove of items
        NSAlert* alert = [NSAlert alertWithMessageText:@"Are you sure you want to delete the selected template?" defaultButton:@"Cancel" alternateButton:@"Delete" otherButton:NULL informativeTextWithFormat:@"You cannot undo this operation."];
        NSInteger result = [alert runModal];
        
        if (result == NSAlertDefaultReturn)
        {
            return;
        }
        
        NSInteger idx = [[self selectionIndexes] firstIndex];
        PropertyInspectorTemplate* templ = [[self content] objectAtIndex:idx];
        
        [[CocosBuilderAppDelegate appDelegate].propertyInspectorHandler removeTemplate:templ];
        
        return;
    }
    
    [super keyDown:theEvent];
}

@end