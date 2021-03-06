// Hive Mobile
// Copyright (C) 2008 Hive Solutions Lda.
//
// This file is part of Hive Mobile.
//
// Hive Mobile is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Hive Mobile is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Hive Mobile. If not, see <http://www.gnu.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision: 2390 $
// __date__      = $LastChangedDate: 2009-04-02 08:36:50 +0100 (qui, 02 Abr 2009) $
// __copyright__ = Copyright (c) 2008 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "Dependencies.h"

#import "HMEntityDelegate.h"

/**
 * Provides an abstraction for mapping entities
 * and their operations with remote logic routes.
 */
@interface HMEntityAbstraction : NSObject<UIActionSheetDelegate> {
    @private
    NSObject<HMEntityDelegate> *_entityDelegate;
}

/**
 * The entity delegate to be used by the
 * entity abstraction.
 */
@property (assign) NSObject<HMEntityDelegate> *entityDelegate;

/**
 * Constructor of the class.
 *
 * @param entityDelegate The entity delegate to be used.
 */
- (id)initWithEntityDelegate:(NSObject<HMEntityDelegate> *)entityDelegate;

/**
 * Constructs a class level url from the entity name
 * and the serializer name.
 *
 * @param entityName The name of the entity.
 * @param serializerName The name of the serializer.
 * @return The constructed class level url.
 */
- (NSString *)constructClassUrl:(NSString *)entityName serializerName:(NSString *)serializerName;

/**
 * Constructs a object level url from the entity name
 * and the serializer name.
 *
 * @param entityName The name of the entity.
 * @param serializerName The name of the serializer.
 * @return The constructed object level url.
 */
- (NSString *)constructObjectUrl:(NSString *)entityName serializerName:(NSString *)serializerName;

/**
 * Constructs a object composite level url from the entity name
 * the operation name and the serializer name.
 *
 * @param entityName The name of the entity.
 * @param operationName The name of the operation.
 * @param serializerName The name of the serializer.
 * @return The constructed object composite level url.
 */
- (NSString *)constructObjectCompositeUrl:(NSString *)entityName operationName:(NSString *)operationName serializerName:(NSString *)serializerName;

/**
 * Retrieves the remote url for the given operation type.
 *
 * @param operationType The type of the operation.
 * @param entityName The name of the entity.
 * @param serializerName The name of the serializer.
 * @return The remote url for the given operation type.
 */
- (NSString *)getRemoteUrlForOperation:(HMItemOperationType)operationType entityName:(NSString *)entityName serializerName:(NSString *)serializerName;

/**
 * Retrieves the url considered to be the base
 * in the current system.
 *
 * @return The current base url.
 */
+ (NSString *)getBaseUrl;

@end
