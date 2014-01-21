//
//  DateHelper.m
//  Remember when
//
//  Created by René Fernández on 08/05/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

-(NSDictionary*) timeFromDate:(NSDate*) d{
	
	NSDate *endDate = [NSDate date];
	
	
	NSCalendar* myCalendar = [NSCalendar currentCalendar];
	
	NSDateComponents* components = [myCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:d toDate:endDate options:0];
	
	NSNumber *years =  [NSNumber numberWithInteger:[components year]];
    NSNumber *months =  [NSNumber numberWithInteger:[components month]];
    NSNumber *days =  [NSNumber numberWithInteger:[components day]];
	NSNumber *hours =  [NSNumber numberWithInteger:[components hour]];
	NSNumber *minutes =  [NSNumber numberWithInteger:[components minute]];
	
	NSDictionary *returned = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:years,months,days,hours,minutes,nil] forKeys:[NSArray arrayWithObjects:@"years",@"months",@"days",@"hours",@"minutes",nil]];
	
	return returned;
}

-(NSString*) fullDateFromDictionary:(NSDate*) d{
	
	NSDictionary *dic = [self timeFromDate:d];
	
	NSString *years = [self getFormated:[dic objectForKey:@"years"]singular:@"year" plural:@"years"];
	NSString *months = [self getFormated:[dic objectForKey:@"months"]singular:@"month" plural:@"months"];
	NSString *days = [self getFormated:[dic objectForKey:@"days"]singular:@"day" plural:@"days"];
	NSString *hours = [self getFormated:[dic objectForKey:@"hours"]singular:@"hour" plural:@"hours"];
	NSString *minutes = [self getFormated:[dic objectForKey:@"minutes"]singular:@"minute" plural:@"minutes"];
	
	NSString* sufix=@"";
	NSString* prefix=@"";
	if([self anyValueIsNegative:[[NSArray alloc] initWithObjects:[dic objectForKey:@"years"],[dic objectForKey:@"months"],[dic objectForKey:@"days"],[dic objectForKey:@"hours"],[dic objectForKey:@"minutes"], nil]]){
		prefix = @"In ";
	}else{
		sufix=@"ago";
	}
	
	return [NSString stringWithFormat:@"%@%@%@%@%@%@%@",prefix,years,months,days,hours,minutes,sufix];
	
}

- (BOOL) anyValueIsNegative:(NSArray*) values{
	
	for (NSNumber *v in values) {
		int time = [v intValue];
		if(time<0) return YES;
	}
	
	return NO;
	
}


- (NSString*) getFormated:(NSNumber*) y singular:(NSString*) s plural:(NSString*) p{
	
	int time = [y intValue];
	
	if(time==0) return @"";
	
	if(time==1) return [NSString stringWithFormat:@"%d %@ ",time,s];
	
	if(time > 1)return [NSString stringWithFormat:@"%d %@ ",time,p];
	
	if(time<0){
		time= time*(-1);
	}
	return [NSString stringWithFormat:@"%d %@ ",time,p];
	//if(years<0) return @"1 year";
	
}


@end
