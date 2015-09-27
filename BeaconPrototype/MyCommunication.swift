//
//  MyCommunication.swift
//  iBeaconHome10
//
//  Created by keinakagawa on 2015/09/23.
//  Copyright © 2015年 K. All rights reserved.
//  Released under the MIT license
//  http://opensource.org/licenses/mit-license.php

import Foundation

class MyCommunication:NSObject {
    
    
    // 例外の定義
    enum MyCommunicationError: ErrorType {
        case NoInterNetConnectionError
        case NeverToReturnError
        case CoudNotJsonToDicError
    }
    
    // クラスを初期化
    override init() {
        print("初期化")
    }
    
    
    // インターネットに出れるか確認
    func chkInterNetConnection()-> Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability!.isReachable() {
            print("インターネット接続あり")
            //return false // TEST用
            return true
        } else {
            print("インターネット接続なし")
            return false
        }
    }
    
    // JSON のオブジェクトを NSDictionary に変換
    func jsonToDic(data:NSData) throws -> NSMutableDictionary {
        do{
            let dic = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)
            return dic as! NSMutableDictionary
        }
        catch{
        }
        throw MyCommunicationError.CoudNotJsonToDicError
    }
    
    // Post をする
    func doPost(para:String, urlstr:String) throws -> NSData{
        // まずPOSTで送信したい情報をセット
        let strData = para.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url = NSURL(string: urlstr)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        // 通信状況が安定しないと失敗するのでリトライを行う。
        // swift は　return　文の後を処理しないのでbreakは不要
        for(var retryNum = 0; retryNum < 5; retryNum++){
            do {
                // インターネットに出れるかチェックする
                // でれなければ例外を発行してキャッチさせる。
                if self.chkInterNetConnection() == false {
                    throw MyCommunicationError.NoInterNetConnectionError
                }
                // Postする
                let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                print("Post成功")
                return data
            }
            catch {
                sleep(3)
                print("エラー発生 リトライ回数＝" + String(retryNum))
                // ここで処理を何も書かなくても OK の様子
            }
            
        }
        throw MyCommunicationError.NeverToReturnError
        //return "Error"
        
    }
    
    //Post と jsonToDic をまとめて実行
    func doPostAndJsonToDic(para:String, urlstr:String) throws -> NSMutableDictionary {
        var data = NSData()
        do {
            data = try self.doPost(para,urlstr: urlstr)
        }
        catch {
            throw MyCommunicationError.NeverToReturnError
        }
        
        do {
            let dic = try self.jsonToDic(data) as NSMutableDictionary
            return dic
        }
        catch {
            throw MyCommunicationError.CoudNotJsonToDicError
        }
    }
    
}