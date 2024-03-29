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
	
	//Knoten laden
	if ([self loadNodeList:@"DocumentsOrdner"] == false)
		return;
	
	
	
	//Route berechnen
	NSMutableArray* route = [[NSMutableArray alloc]init];
	
	NSLog(@"Start Calculation");
    route = [self routeFromNodeID:@"1" to:@"55"];
	NSLog(@"Route : %@", route);
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (bool)loadNodeList:(NSString *)oFolder

{
	
	NSString *pathString =  [NSString stringWithFormat:@"%@/%@",documentsDir,oFolder];
	
	NSString *fullPath = [NSString stringWithFormat:@"%@/nodes.xml",pathString];
	
	NSString* theContents = [[NSString alloc] initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
	
	
	//xml laden falls vorhanden
	structureXML = [TBXML newTBXMLWithXMLString:theContents error:nil];
	rootElement = structureXML.rootXMLElement;
	
	if (!structureXML) {
		NSLog(@"No structur file could be found or structur file i incorrect : %@", fullPath);
		return false;
	}
	
	//Array mit der anzahl der Ids erstellen um später für jede ID den kürzestens Weg bis dato zu speichern
	nodeIDs = [[NSMutableArray alloc]init];
	int nodeCount = [TBXMLFunctions getCountOfChildsFromElement:rootElement];
	for (int i = 0; i <= nodeCount; i++)
	{
		[nodeIDs addObject:@"-1"];
	}
	
	return true;
	
}

-(NSMutableArray*) routeFromNodeID:(NSString*)startID
								to:(NSString*)endID
{

	NSMutableArray* possibleRoute = [[NSMutableArray alloc]init];
	
	NSMutableArray* currentBestRoute = [[NSMutableArray alloc]init];
	[currentBestRoute addObject:startID];
	[currentBestRoute addObject:@"-1"];
	
	NSMutableArray* nextNodes = [[NSMutableArray alloc]init];
    
    [TBXMLFunctions getAllNextNodesFromElement:[TBXMLFunctions getElement:rootElement ByID:startID] toArray:nextNodes];
    
	for ( NSMutableArray* nextNode in nextNodes)
    {
		if ([[nextNode objectAtIndex:0] isEqualToString:endID]) //falls schon am Ende dann zurückgeben
		{
			return nextNode;
		}
		
		//nächste ID hinzufügen - hier müssen wir aus der ID eine Array für später machen
		NSMutableArray* tempNodeArray = [[NSMutableArray alloc]init];
		[tempNodeArray addObject:startID];
		[tempNodeArray addObject:[nextNode objectAtIndex:0]];
		
		NSMutableArray* tempNode = [[NSMutableArray alloc]init];
		[tempNode addObject:tempNodeArray];//temporäres Array speichern
		[tempNode addObject:[nextNode objectAtIndex:1]];//Kosten speichern
		
		[possibleRoute addObject:tempNode];
		

    }
	
	//falls nicht am Ende, dann eine ebene tiefer
	[self calculateNextNodeLevelFrom:possibleRoute withCurrentBestRoute:currentBestRoute toEndID:endID];
	
	return [currentBestRoute objectAtIndex:0];
	
	
	
}


-(NSMutableArray*)calculateNextNodeLevelFrom:(NSMutableArray*)currentNodes
						withCurrentBestRoute:(NSMutableArray*)currentBestRoute
									 toEndID:(NSString*)endID

{
	NSMutableArray* nextNodesForCurrentNode = [[NSMutableArray alloc]init];
	NSMutableArray* nextPossibleNotes = [[NSMutableArray alloc]init];
		
	for (NSMutableArray* currentNode in currentNodes)
    {
		NSString* lastID = [[currentNode objectAtIndex:0]objectAtIndex:[[currentNode objectAtIndex:0]count]-1];
		
		[TBXMLFunctions getAllNextNodesFromElement:[TBXMLFunctions getElement:rootElement ByID:lastID] toArray:nextNodesForCurrentNode];
		
		for (NSMutableArray* nextNodeForCurrentNode in nextNodesForCurrentNode)
		{
			NSMutableArray* tempArray = [[NSMutableArray alloc]init];
			
			//Kosten zusammenfassen
			CGFloat costs = [[currentNode objectAtIndex:1]floatValue] + [[nextNodeForCurrentNode objectAtIndex:1]floatValue];
			
			//Prüfen ob wir am Ende sind
			if ([[nextNodeForCurrentNode objectAtIndex:0] isEqualToString:endID]) //falls schon am Ende dann zurückgeben
			{
				//Prüfen ob Kosten kleiner sind, also der Weg bessern
				if (costs < [[currentBestRoute objectAtIndex:1]floatValue] || [[currentBestRoute objectAtIndex:1]floatValue] < 0)
				{
					//bis dato beste route löschen
					[currentBestRoute removeAllObjects];
					
					//nächste ID hinzufügen
					[tempArray addObjectsFromArray:[currentNode objectAtIndex:0]];
					[tempArray addObject:[nextNodeForCurrentNode objectAtIndex:0]];
					[currentBestRoute addObject:tempArray];
					
					//Kosten speichern
					[currentBestRoute addObject:[NSString stringWithFormat:@"%f",costs]];
				}//sonst nicht speichern
				
				
			}else{//wenn nicht am ende, dann speichern
				
				//Optimierungen
				//1. prüfen ob ID bereits verwendet wurde => rücklauf
				//2. wenn Kosten bereits größer als aktuell beste Route
				//3. wenn wir bereits einen kürzeren Weg zum aktuellen Knoten kennen
				bool stepOver = false;
				
				//Rücklauf
				for (NSString* currentID in [currentNode objectAtIndex:0])
				{
					
					if ([currentID isEqualToString:[nextNodeForCurrentNode objectAtIndex:0]])
					{
						stepOver = true;
						break;
					}
				}
					
				//Kosten
				if (costs > [[currentBestRoute objectAtIndex:1]floatValue] && [[currentBestRoute objectAtIndex:1]floatValue] > 0)
				{
					stepOver = true;
				}
				
				//kürzerer Weg
				if (costs >= [[nodeIDs objectAtIndex:[[nextNodeForCurrentNode objectAtIndex:0] intValue]]floatValue] && [[nodeIDs objectAtIndex:[[nextNodeForCurrentNode objectAtIndex:0] intValue]]floatValue] > 0)
				{
					stepOver = true;
				}else{
					[nodeIDs setObject:[NSString stringWithFormat:@"%f",costs] atIndexedSubscript:[[nextNodeForCurrentNode objectAtIndex:0] intValue]];
				}
					
					

				
				//neuer sinnvoller Knoten, also abspeichern
				if (stepOver == false)
				{
					NSMutableArray* tempNode = [[NSMutableArray alloc]init];
					
					//nächste ID hinzufügen
					[tempArray addObjectsFromArray:[currentNode objectAtIndex:0]];
					[tempArray addObject:[nextNodeForCurrentNode objectAtIndex:0]];
					[tempNode addObject:tempArray];
					
					//Kosten speichern
					[tempNode addObject:[NSString stringWithFormat:@"%f",costs]];
					
					//tempNode speichern
					[nextPossibleNotes addObject:tempNode];
				}

				
			
			}
			
			
			
		}
		
    }
	
	if ([nextPossibleNotes count]>0)
	{
		[self calculateNextNodeLevelFrom:nextPossibleNotes withCurrentBestRoute:currentBestRoute toEndID:endID];
	}
		
	
	
	return currentBestRoute;
}






@end
