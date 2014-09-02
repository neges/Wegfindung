//
//  ViewController.h
//  Wegfindung
//
//  Created by Mac on 29.08.14.
//  Copyright (c) 2014 itm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "TBXMLFunctions.h"


@interface ViewController : UIViewController
{
	
	NSString* documentsDir; //Pfad zum dokumenten ordner

	TBXML* structureXML; //structureXML
    TBXMLElement* rootElement;
	
	NSMutableArray* nodeIDs;
	
}

@end
