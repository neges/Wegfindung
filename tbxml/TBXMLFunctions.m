//
//  TBXMLFunctions.m
//  Template
//
//  Created by Mac on 25.10.13.
//  Copyright (c) 2013 itm. All rights reserved.
//

#import "TBXMLFunctions.h"

@implementation TBXMLFunctions


#pragma mark -
#pragma mark tbxml Methodes
#pragma mark -

+(int)getCountOfChildsFromElement:(TBXMLElement*)element
{
	TBXMLElement* childs = element->firstChild;
	int count = 0;
	
	
	if (childs)
	{
		do
		{
			count = count + 1;
			
		}while ((childs = childs->nextSibling));
	}
	
	return count;
	
}


+(TBXMLElement*) getElement:(TBXMLElement*)element
					 ByName:(NSString*) elementName
{
	
	do{
		
		
		TBXMLAttribute *attribute = element->firstAttribute;
		
		while (attribute)
		{
			if ([[TBXML attributeValue:attribute] isEqualToString:elementName])
			{
				return element;
			}
			
			attribute = attribute->next;
			
		}
		
		if (element->firstChild)
		{
			TBXMLElement* tempElement = [self getElement:element->firstChild ByName:elementName];
			if (tempElement) {
				return tempElement;
			}
		}
		
		
	}while ((element = element->nextSibling));
	
	return nil;
	
	
}

+(void)getAllElements:(TBXMLElement*)element
{
	
	
	do{
		
		
		if (element->firstAttribute)
		{
			
			TBXMLAttribute *attribute = element->firstAttribute;
			
			while (attribute)
			{
				//NSLog(@"%@ : %@ = %@", [TBXML elementName:element], [TBXML attributeName:attribute], [TBXML attributeValue:attribute]);
				
				NSLog(@"%@ = %@", [TBXML elementName:element], [TBXML attributeValue:attribute]);
				
				attribute = attribute->next;
				
			}
			
		}
		
		if (element->firstChild)
		{
			[self getAllElements:element->firstChild];
		}
		
		
	}while ((element = element->nextSibling));
	
}

+(void)getAllElements:(TBXMLElement*)element
		   withGroups:(bool)wGroups
			  toArray:(NSMutableArray *)elementArray
{
	
	do
	{
		
		if (element->firstAttribute)
		{
		
			TBXMLAttribute *attribute = element->firstAttribute;
			
			while (attribute)
			{
				if (wGroups) {
                    if ([[TBXML attributeName:attribute] isEqualToString:@"name"])
                    {
                        [elementArray addObject: [TBXML attributeValue:attribute]];
                    }
					
				}else{
					if (!element->firstChild)
					{
                        if ([[TBXML attributeName:attribute] isEqualToString:@"name"])
                        {
                            [elementArray addObject: [TBXML attributeValue:attribute]];
                        }
                        
						
					}
					
					
				}
				//NSLog(@"%@ : %@ = %@", [TBXML elementName:element], [TBXML attributeName:attribute], [TBXML attributeValue:attribute]);
				
				attribute = attribute->next;
				
			}
			
		}
		
		if (element->firstChild)
		{
			[self getAllElements:element->firstChild withGroups:wGroups toArray:elementArray];
		}
		
		
	}while ((element = element->nextSibling));
	
}


+(NSMutableArray*)getAllTableViewSubElements:(TBXMLElement*)topElement
{

    NSMutableArray* elementArray = [[NSMutableArray alloc]init];
    
    if (!topElement->firstChild)
        return elementArray;
    
    
    //Eigenschaften der Unterobjekte holen
    TBXMLElement* element = topElement->firstChild;
    
        do
        {
			if (![[self elementName:element] isEqualToString:@"metaDataBlock"])
			{
			
				NSMutableArray* tempArray = [[NSMutableArray alloc]init];
				
				if (element->firstAttribute)
				{
					
					
					TBXMLAttribute *attribute = element->firstAttribute;
					
					
					
					[tempArray addObject:[TBXML elementName:element]];
					
					
					while (attribute)
					{
						
						[tempArray addObject:[TBXML attributeValue:attribute]];
						
						
						attribute = attribute->next;
						
					}
					
					[elementArray addObject: tempArray];
					
				}
            }
            
        }while ((element = element->nextSibling));
	
		
	 return elementArray;
	
}

+(NSMutableArray*)getMetaDateOfElements:(TBXMLElement*)topElement
{
	
    NSMutableArray* elementArray = [[NSMutableArray alloc]init];
    
    if (!topElement->nextSibling)
        return elementArray;
    
    
    //Eigenschaften der Unterobjekte holen
    TBXMLElement* element = topElement->nextSibling;
    
	if ([[self elementName:element] isEqualToString:@"metaDataBlock"])
	{
		
		if (!element->firstChild)
			return elementArray;
		
		TBXMLElement* metaDataElement = element->firstChild;
		
		
		
		while (metaDataElement)
		
		{
			NSMutableArray* tempArray = [[NSMutableArray alloc]init];
			
			TBXMLAttribute *attribute = metaDataElement->firstAttribute;
			
			while (attribute)
			{
				
				[tempArray addObject:[TBXML attributeValue:attribute]];
				
				
				attribute = attribute->next;
				
			}
			
			[elementArray addObject: tempArray];
				
			
			metaDataElement = metaDataElement->nextSibling;
		}
		
	}
	
	return elementArray;
	
}


+(NSString*)getAttribute:(NSString*)attrib
			   OfElement:(TBXMLElement*)element
{
	if (!element)
		return @"";
	
	if (!element->firstAttribute)
		return @"";
	
	TBXMLAttribute *attribute = element->firstAttribute;
	
	while (attribute)
	{
		
		if ([[TBXML attributeName:attribute] isEqualToString:attrib])
		{
			return [TBXML attributeValue:attribute];
		}
		
		attribute = attribute->next;
	}
	
	return @"";
	
}

+(NSString*)getTypeOfElement:(TBXMLElement*)element
{
	
	return [TBXML elementName:element];
	
}

+(NSMutableArray*)getAllParentElementsFrom:(TBXMLElement*)element

{
	NSMutableArray* elementArray = [[NSMutableArray alloc]init];
	
	
	TBXMLElement *tempElement = element;
	
	if (tempElement) {
		
            NSMutableArray* tempArray = [[NSMutableArray alloc]init];
			
            if (tempElement->firstAttribute)
            {
                
                
                TBXMLAttribute *attribute = tempElement->firstAttribute;
                
                
                
                [tempArray addObject:[TBXML elementName:tempElement]];
                
                
                while (attribute)
                {
                    
					[tempArray addObject:[TBXML attributeValue:attribute]];
                    
                    
                    attribute = attribute->next;
                    
                }
                
                [elementArray addObject: tempArray];
                
            }
        
		
		while (tempElement->parentElement)
		{
			
			tempElement = tempElement->parentElement;
			
			NSMutableArray* tempArray = [[NSMutableArray alloc]init];
			
			if (tempElement->firstAttribute)
			{
				
				
				TBXMLAttribute *attribute = tempElement->firstAttribute;
				
				
				
				[tempArray addObject:[TBXML elementName:tempElement]];
				
				
				while (attribute)
				{
					
					[tempArray addObject:[TBXML attributeValue:attribute]];
					
					
					attribute = attribute->next;
					
				}
				
				[elementArray addObject: tempArray];
				
			}
				
						
		}
		
	}
	
	NSMutableArray* reversedArray = [[NSMutableArray alloc] initWithArray:[[[[NSArray alloc] initWithArray: elementArray] reverseObjectEnumerator] allObjects]];
	
	return reversedArray;
	
	
	
}






#pragma mark -
#pragma mark save in tbxml
#pragma mark -


+(bool)saveAttributForName:(NSString*)aName
				 withValue:(char*) aValue
				 toElement:(TBXMLElement*)aElement
{


	TBXMLAttribute *attribute = aElement->firstAttribute;
	
	while (attribute)
	{
		
		if ([[TBXML attributeName:attribute] isEqualToString:aName])
		{
			
			attribute->value = aValue;
			
			return true;
		}
		
		attribute = attribute->next;
	}
	
	return false;




	return true;

}



#pragma mark -
#pragma mark Work
#pragma mark -

+(void)getAllChilds:(TBXMLElement*)element
		   toArray:(NSMutableArray *)elementArray
{
	TBXMLElement* childs = element->firstChild;
	
	if (childs)
	{
		do
		{
			[elementArray addObject: [TBXMLFunctions getAttribute:@"name" OfElement:childs]];
			
		}while ((childs = childs->nextSibling));
	}
	
}

+(void)getAllChilds:(TBXMLElement*)element
	  forValueNamed:(NSString*)valueNamed
		  withValue:(NSString*)value
			toArray:(NSMutableArray *)elementArray
{
	TBXMLElement* childs = element->firstChild;
	
	if (childs)
	{
		do
		{
			
			if ([[TBXMLFunctions getValue:valueNamed OfElement:childs] isEqualToString:value])
				[elementArray addObject: [TBXMLFunctions getAttribute:@"name" OfElement:childs]];
			
		}while ((childs = childs->nextSibling));
	}
	
}


+(NSString*)getValue:(NSString*)value
		   OfElement:(TBXMLElement*)element
{
	TBXMLElement* child = element->firstChild;
	
	if (child)
	{
		do
		{
			if ([[TBXML elementName:child] isEqualToString:value]){
				
				return [TBXML textForElement:child];
				
			}
			
		}while ((child = child->nextSibling));
	}
	
	return @"";
	
}

+(NSMutableArray*)getValues:(NSString*)value
		   OfElement:(TBXMLElement*)element
{
	NSMutableArray* tempArray = [[NSMutableArray alloc]init];
	
	TBXMLElement* child = element->firstChild;
	
	if (child)
	{
		do
		{
			if ([[TBXML elementName:child] isEqualToString:value]){
				
				[tempArray addObject:[TBXML textForElement:child]];
				
			}
			
		}while ((child = child->nextSibling));
	}
	
	return tempArray;
	
}


+(NSMutableArray*)getAllInfectedObjectsForWorkInstruction:(TBXMLElement*)topElement
{
	
    NSMutableArray* elementArray = [[NSMutableArray alloc]init];
    
    if (!topElement->firstChild)
        return elementArray;
    
    
    //Eigenschaften der Unterobjekte holen
    TBXMLElement* element = topElement->firstChild;
    
	do
	{
		NSMutableArray* tempArray = [[NSMutableArray alloc]init];
		
		if (element->firstAttribute)
		{
			
			
			TBXMLAttribute *attribute = element->firstAttribute;
			
			
			
			[tempArray addObject:[TBXML elementName:element]];
			
			
			while (attribute)
			{
				
				[tempArray addObject:[TBXML attributeValue:attribute]];
				
				
				attribute = attribute->next;
				
			}
			
			if ([tempArray count] > 2){
				if ([[tempArray objectAtIndex:2] isEqualToString:@"visible"])
					[elementArray addObject: tempArray];
			}
			
			
		}
		
		
	}while ((element = element->nextSibling));
	
	
	return elementArray;
	
}


+(void)getAllHintsForStep:(TBXMLElement*)element
			toArray:(NSMutableArray *)elementArray
{
	
    [elementArray removeAllObjects];
    
    TBXMLElement* childs = element->firstChild;
	
	if (childs)
	{
		do
		{
			
			if ([[TBXMLFunctions elementName:childs] isEqualToString:@"hint"])
            {
                NSMutableArray* tempArray = [[NSMutableArray alloc]init];
                
                [tempArray addObject: [TBXMLFunctions getAttribute:@"id" OfElement:childs]];
                [tempArray addObject: [TBXMLFunctions getAttribute:@"name" OfElement:childs]];
                [tempArray addObject: [TBXMLFunctions getAttribute:@"posx" OfElement:childs]];
                [tempArray addObject: [TBXMLFunctions getAttribute:@"posy" OfElement:childs]];
                [tempArray addObject: [TBXMLFunctions getAttribute:@"posz" OfElement:childs]];
                
                [elementArray addObject:tempArray];
                
                
            }
			
		}while ((childs = childs->nextSibling));
	}
	
}


+(TBXMLElement*) getElement:(TBXMLElement*)element
					 ByID:(NSString*) elementID
{
	
	do{
		
		
		TBXMLAttribute *attribute = element->firstAttribute;
		
		while (attribute)
		{
            
			if ([[TBXML attributeValue:attribute] isEqualToString:elementID] && [[TBXML attributeName:attribute] isEqualToString:@"id"])
			{
				return element;
			}
			
			attribute = attribute->next;
			
		}
		
		if (element->firstChild)
		{
            
            if ([[TBXMLFunctions getTypeOfElement:element->firstChild] isEqualToString:@"node"])
            {
                TBXMLElement* tempElement = [self getElement:element->firstChild ByID:elementID];
                if (tempElement) {
                    return tempElement;
                }
            }

		}
		
		
	}while ((element = element->nextSibling));
	
	return nil;
	
	
}


+(void)getAllNextNodesFromElement:(TBXMLElement*)element
                  toArray:(NSMutableArray *)elementArray
{
	
    [elementArray removeAllObjects];
    
	if (element == nil)
		return;
	
    TBXMLElement* childs = element->firstChild;
	
	if (childs)
	{
		do
		{
			
			if ([[TBXMLFunctions elementName:childs] isEqualToString:@"next"])
            {
                NSMutableArray* tempArray = [[NSMutableArray alloc]init];
                
                [tempArray addObject: [TBXMLFunctions getAttribute:@"id" OfElement:childs]];
                [tempArray addObject: [TBXMLFunctions getAttribute:@"cost" OfElement:childs]];
                
                [elementArray addObject:tempArray];
                
                
            }
			
		}while ((childs = childs->nextSibling));
	}
	
}




#pragma mark -
#pragma mark archiv
#pragma mark -

-(void)getLogAllElements:(TBXMLElement*) rootElement
{
	
	if (rootElement)
	{
		//[self getXMLElements:rootElement];
		
		NSString* searchName = @"screws_FRONT";
		
		
		TBXMLElement* foundedElement = [TBXMLFunctions getElement:rootElement ByName:searchName];
		if (foundedElement) {
			TBXMLAttribute *attribute = foundedElement->firstAttribute;
			NSLog(@"%@ = %@", [TBXML elementName:foundedElement], [TBXML attributeValue:attribute]);
			
			
			
			NSLog(@"----------Childs------------");
			if (foundedElement->firstChild)
				[self getLogAllElements:foundedElement->firstChild];
			else
				NSLog(@"none");
			
			
			
			NSLog(@"----------Parent------------");
			if (foundedElement->parentElement)
			{
				TBXMLElement* elementParent = foundedElement->parentElement;
				if (foundedElement) {
					TBXMLAttribute *attribute = elementParent->firstAttribute;
					NSLog(@"%@ = %@", [TBXML elementName:elementParent], [TBXML attributeValue:attribute]);
				}
			}else
				NSLog(@"none");
			
			
		}else
			NSLog(@"This element does not exists");
		
		
	}
}

@end
