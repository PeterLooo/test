//
//  MessageSendViewController.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol MessageSendToastDelegate: NSObjectProtocol {
    
    func setMessageSendToastText(text: String)
}

extension MessageSendViewController {
    
    func setVC(messageSendType: String, navTitle: String) {
        
        self.messageSendType = messageSendType
        self.navTitle = navTitle
    }
}

class MessageSendViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    enum Section : Int, CaseIterable {
        case NotificationList = 0
        case Topic
        case Content
    }
    
    private var presenter: MessageSendPresenter?
    private var sendList: MessageSendUserListResponse?
    private var messageSendType: String?
    private var messageTopic: String?
    private var messageContent: String?
    private var navTitle: String?
    
    weak var delegate: MessageSendToastDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = MessageSendPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTouchTableView))
        tableView.addGestureRecognizer(gesture)
        
        presenter?.getSendUserList(messageSendType: messageSendType!)
        
        setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
        setNavTitle(title: navTitle!)
        setNavButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageSendNotificationListCell", bundle: nil), forCellReuseIdentifier: "MessageSendNotificationListCell")
        tableView.register(UINib(nibName: "MessageSendTopicCell", bundle: nil), forCellReuseIdentifier: "MessageSendTopicCell")
        tableView.register(UINib(nibName: "MessageSendContentCell", bundle: nil), forCellReuseIdentifier: "MessageSendContentCell")
        
        sendButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
    }
    
    @objc func onTouchTableView(_ sender: UITableView) {
        
        self.view.endEditing(true)
    }
    
    private func setNavButton() {
        
        let cancelBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(self.onTouchCancel))
        cancelBarButtonItem.tintColor = UIColor.init(named: "通用綠")
        
        setCustomLeftBarButtonItem(barButtonItem: cancelBarButtonItem)
    }
    
    private func setAlert(message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "通用綠"), forKey: "titleTextColor")
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func onTouchCancel(){
           
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTouchSend(_ sender: UIButton) {
        
        var sendKeyList: [String] = []
        var enabledSendUserList: [UserStatus] = []
        
        sendList?.sendUserList.forEach({ (status) in
            
            if status.defaultMark == true {
                
                sendKeyList.append(status.sendKey!)
            }
            
            if status.enabledMark == true {
                
                enabledSendUserList.append(status)
            }
        })
        
        let request = MessageSendRequest()
        request.sendType = messageSendType
        request.sendKeyList = sendKeyList
        request.messageTopic = messageTopic
        request.messageText = messageContent
        
        if request.messageTopic == "請填寫" {
            
            setAlert(message: "請輸入訊息主旨")
        } else if enabledSendUserList.count != 0 && request.sendKeyList?.count == 0 {
            
            setAlert(message: "通知名單至少需選擇一位訊息發送對象")
        } else {
            
            presenter?.messageSend(messageSendRequest: request)
        }
    }
}

extension MessageSendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = Section(rawValue: section)
        
        switch section {
            
        case .NotificationList:
            return sendList?.sendUserList.count ?? 0
            
        case .Topic:
            return 1
        
        case .Content:
            return 1
        
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        
        case .NotificationList:
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendNotificationListCell") as! MessageSendNotificationListCell
            (cell as! MessageSendNotificationListCell).delegate = self
            (cell as! MessageSendNotificationListCell).setCell(userStatus: sendList?.sendUserList[indexPath.row] ?? UserStatus())
            
            if indexPath.row != 0 {
                
                (cell as! MessageSendNotificationListCell).cellTitleHidden()
            }
            
        case .Topic:
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendTopicCell") as! MessageSendTopicCell
            (cell as! MessageSendTopicCell).messageSendTopicCellDelegate = self
            messageTopic = (cell as! MessageSendTopicCell).messageTopic.text
            
        case .Content:
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendContentCell") as! MessageSendContentCell
            (cell as! MessageSendContentCell).messageSendContentCellDelegate = self
            messageContent = (cell as! MessageSendContentCell).messageContent.text
        
        case .none:
            cell = UITableViewCell()

        }
        
        return cell
    }
}

extension MessageSendViewController: UITableViewDelegate {}

extension MessageSendViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.view.endEditing(true)
    }
}

extension MessageSendViewController: MessageSendNotificationListCellDelegate {
   
    func reSetCell(userStatus: UserStatus) {
        
        self.sendList?.sendUserList.forEach({ (status) in
            
            if status.sendKey == userStatus.sendKey {
                
                status.defaultMark = userStatus.defaultMark
            }
        })
        
        tableView.reloadData()
    }
    
}

extension MessageSendViewController: MessageSendTopicCellDelegate {
    
    func didChange(topicText: String) {
        
        messageTopic = topicText
    }
}

extension MessageSendViewController: MessageSendContentCellDelegate {
    
    func didChange(contentText: String) {
        
        messageContent = contentText
    }
}

extension MessageSendViewController: MessageSendViewProtocol {

    func setSendUserList(messageSendUserListResponse: MessageSendUserListResponse) {
        
        sendList = messageSendUserListResponse
        tableView.reloadData()
    }
    
    func messageSendSuccess() {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.setMessageSendToastText(text: "訊息發送成功")
        })
    }
}
