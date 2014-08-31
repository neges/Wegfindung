//
//  ViewController.m
//  Wegfindung
//
//  Created by Mac on 29.08.14.
//  Copyright (c) 2014 itm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//Dokuenten Ordner holen
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDir = [paths objectAtIndex:0];
	
	//ohne DocumentsOrdner
	documentsDir = [[NSBundle mainBundle] resourcePath];
	
	[self loadNodeList:@"DocumentsOrdner"];
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadNodeList:(NSString *)oFolder

{
	
	NSString *pathString =  [NSString stringWithFormat:@"%@/%@",documentsDir,oFolder];
	
	NSString *fullPath = [NSString stringWithFormat:@"%@/nodes.xml",pathString];
	
	NSString* theContents = [[NSString alloc] initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
	
	
	//xml laden falls vorhanden
	structureXML = [TBXML newTBXMLWithXMLString:theContents error:nil];
	rootElement = structureXML.rootXMLElement;
	
	if (!structureXML) {
		NSLog(@"No structur file could be found or structur file i incorrect : %@", fullPath);
		return;
	}
	
    NSMutableArray* route = [[NSMutableArray alloc]init];
    [route addObject:<#(id)#>]
    [self routeFromNodeID:@"1" to:@"6" returnedRoute:route];
    NSLog(@"%@",route);
    
	

	
}

-(void) routeFromNodeID:(NSString*)startID
                     to:(NSString*)endID
          returnedRoute:(NSMutableArray*)rRoute
{

    NSMutableArray* nextNodes = [[NSMutableArray alloc]init];
    
    [TBXMLFunctions getAllNextNodesFromElement:[TBXMLFunctions getElement:rootElement ByID:startID] toArray:nextNodes];
    
	for (NSMutableArray* nextNode in nextNodes) //Prüfen ob wir schon durch sind
    {
        if ([[nextNode objectAtIndex:0] isEqualToString:endID])
        {
            
            return[nextNode objectAtIndex:1];
        }
    }
    for ( NSMutableArray* nextNode in nextNodes) //nicht druch als nochmal durchlaufen und selber aufrufen
    {
        int costs = [[self routeFromNodeID:[nextNode objectAtIndex:0]to:endID]integerValue];
        int sumCosts = [[nextNode objectAtIndex:1]integerValue] + costs;
        return [NSString stringWithFormat:@"%i", sumCosts];
        
        
    }
    


    return nil;
    

}





@end
