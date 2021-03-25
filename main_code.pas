Uses Crt,sysutils;

var staffNumber,customerNumber,transactionNumber,productNumber:longint;
choice,username,password:string;
i,j,k:integer;
fmtID,fmtDate,fmtName,fmtProductID,fmtQuantity,fmtPrice,fmtTPrice:string;

procedure init;
var inp:text;
begin
  assign(inp,'count.txt'); reset(inp);
  readln(inp,staffNumber);
  readln(inp,customerNumber);
  readln(inp,transactionNumber);
  readln(inp,productNumber);
  close(inp);

  fmtID := '%-10s';
  fmtDate := '%-20s';
  fmtName := '%-20s';
  fmtProductID := '%-15s';
  fmtQuantity := '%-15s';
  fmtPrice := '%-10s';
end;

procedure resetCount;
var op:text;
begin
  assign(op,'count.txt');    rewrite(op);
  writeln(op,staffNumber);
  writeln(op,customerNumber);
  writeln(op,transactionNumber);
  writeln(op,productNumber);
  close(op);
end;

procedure loginPage; forward;

procedure login(x:longint); forward;

procedure userRegister(x:longint); forward;


procedure staffHomepage; forward;

procedure changePassword(x:longint;tusername,tpassword:string); forward;

procedure transactionHome; forward;
procedure newTransaction; forward;

procedure manageUser; forward;
procedure staffUserDetail(x:longint;tusername:string); forward;


procedure searchProduct(x:longint); forward;
procedure displayStock(x:longint;tname,ttype,tdiscount,tstock:string); forward;
procedure newProduct; forward;
procedure editStockDetail; forward;
procedure addBookmark; forward;

procedure saleAnalysis; forward;


procedure customerHomepage; forward;

procedure customerBookmark; forward;
procedure deleteBookmark; forward;



procedure loginPage;
begin
  repeat
  clrscr;
  writeln('(Please configure the console size to 130x30)');
  writeln; writeln; writeln;
  writeln('Welcome to ABC supermarket!');
  writeln;
  for i:=1 to 40 do write('*'); writeln; writeln;
  writeln('1 - Staff login');
  writeln('2 - Customer login');
  writeln('3 - New user register');
  writeln('4 - Close application');
  writeln;
  
  repeat
    write('Your choice : ');
    readln(choice);
    if not ( (choice = '1') or (choice = '2') or (choice = '3') or (choice = '4') ) then
    begin
      writeln('Invalid choice! Please enter again');
    end
    else break;
  until false;
  
       if (choice = '1') then login(0)
  else if (choice = '2') then login(1)
  else if (choice = '3') then userRegister(1)
  else if (choice = '4') then
  begin
    resetCount;
    writeln('Thanks for using the application!');
    readln;
    halt;
  end;
  until false;
  
end;

procedure login(x:longint);
var tmpUsername,tmpPassword:string;
pw,us:boolean;
n:longint;
inp:text;
begin
   if (x = 0) then
   begin
     assign(inp,'staffAccount.txt'); reset(inp);
   end
   else
   begin
     assign(inp,'customerAccount.txt'); reset(inp);
   end;
  clrscr;
  repeat
    write('Please input your username : ');
    readln(username);
    write('Please input your password : ');
    readln(password);
	
	reset(inp);
    us:=false; pw:=false;

    while not eof(inp) do
    begin
      readln(inp,tmpUsername);
      readln(inp,tmpPassword);
      if (tmpUsername = username) then
      begin
        us:=true;
        if (tmpPassword = password) then pw:=true;
        break;
      end;
    end;

    if not us then
	begin
		writeln('Invalid username!');
		write('Register? (Y/N) ');
		repeat
		  readln(choice);
		  if (choice = 'Y') then
		  begin
            us:=true;
            close(inp);
			userRegister(1);
            exit;
		  end
		  else if (choice = 'N') then break
		  else writeln('Invalid choice! please enter again');
		until false;
	end
    else writeln('Wrong password! Please input again');
  until us and pw;
  close(inp);

  if (x = 0) then staffHomepage else customerHomepage;
end;


procedure userRegister(x:longint);
var b:boolean;
inp,op:text;
tmpUsername,tmpPassword,tmp,username,password:string;
begin
  clrscr;
  if (x = 0) then assign(inp,'staffAccount.txt')
  else assign(inp,'customerAccount.txt');
  writeln('Please input the following details');
  repeat
    write('Username : '); readln(username);
	if (x = 1) and (length(username) < 6) then
	begin
	  writeln('Username must be at least 6 characters! Please enter again');
	  b:=false;
	  continue;
	end;
    b:=true;
	reset(inp);
    while not eof(inp) do
    begin
	  readln(inp,tmpUsername);
	  if (tmpUsername = username) then
	  begin
	    b:=false;
		break;
	  end;
	end;
	
	if not b then
	begin
	  writeln('Username already exists, please input another username');
	  writeln;
	end;
	
  until b;
  close(inp);
  
  write('Password : '); readln(password);
  repeat
    write('Re-enter password : '); readln(tmpPassword);
	if (password = tmpPassword) then break;
	writeln('Password does not match, please enter again');
  until false;

  write('Confirm register? (Y/N) '); readln(choice);
  
  if choice = 'Y' then
  begin
    if (x = 0) then
    begin
   	  inc(staffNumber);
      assign(op,'staffAccount.txt');
    end
    else
    begin
      inc(customerNumber);
      assign(op,'customerAccount.txt');
    end;

	append(op);
	writeln(op,username);
	writeln(op,password);
	close(op);
	
	if x = 1 then
	begin
	  assign(op,'bookmark.txt'); append(op);
	  writeln(op,username);
	  close(op);
	end;
	
	writeln('Register succeed!');
	writeln('Press enter to continue');
	readln;
  end
  else
  begin
    write('Register failed, try again? (Y/N) '); readln(choice);
	clrscr;
	if choice = 'Y' then userRegister(x);
  end;

end;


procedure staffHomepage;
begin
  repeat
    clrscr;
    writeln('Welcome ',username,'!'); writeln;
    for i:= 1 to 40 do write('*'); writeln; writeln;
    writeln('1 - Transaction');
    writeln('2 - Manage user');
    writeln('3 - Manage stock');
    writeln('4 - Sale analysis');
    writeln('5 - Logout');
    writeln('6 - Change password');
    writeln;

    repeat
      write('Your choice? '); readln(choice);
	  if (choice >= '1') and (choice <= '6') and (length(choice) = 1) then break
	  else
      begin
        writeln('Invalid choice! Please enter again'); writeln;
      end;
    until false;

		 if (choice = '1') then transactionHome
    else if (choice = '2') then manageUser
    else if (choice = '3') then searchProduct(0)
    else if (choice = '4') then saleAnalysis
    else if (choice = '5') then break
    else if (choice = '6') then changePassword(0,username,password);

  until false;
end;

procedure changePassword(x:longint;tusername,tpassword:string);
var tmpPassword,tmpUsername,fileName:string;
inp,op:text;
begin
  clrscr;
  writeln('Change password'); writeln;
  repeat
    write('Old password : '); readln(tmpPassword);
    if (tmpPassword = tpassword) then break;
	writeln('Wrong password! Please enter again'); writeln;
  until false;

  write('New password : '); readln(tpassword);
  repeat
    write('Re-enter password : '); readln(tmpPassword);
	if (tmpPassword = tpassword) then break;
	writeln('Password does not match, please enter again');
	writeln;
  until false;

  if (tusername = username) then password := tmpPassword;
  
  if (x = 0) then fileName := 'staffAccount.txt'
  else fileName := 'customerAccount.txt';
  assign(inp,fileName); reset(inp);
  assign(op,'tmp.txt'); rewrite(op);
  while not eof(inp) do
  begin 
    readln(inp,tmpUsername); writeln(op,tmpUsername);
    readln(inp,tmpPassword);
	if (tmpUsername = tusername) then tmpPassword:=tpassword;
    writeln(op,tmpPassword);
  end;
  close(inp); close(op);
  erase(inp);
  renamefile('tmp.txt',fileName);

  
  writeln;
  writeln('Password changed successfully!');
  writeln('Press enter to continue');
  readln;
end;

procedure transactionHome;
var inp1:text;
transactionID,date,productID,productName,quantity,price:string;
page,lc:longint;
begin
  repeat
    page := 1;
	assign(inp1,'transaction.txt'); reset(inp1);

	repeat 
      clrscr;
      writeln('Transaction HomePage');
	  writeln('Page ',page);    writeln;
  	  write(format(fmtID+fmtDate+fmtProductID,['ID','Date','Product ID']));
	  writeln(format(fmtName+fmtQuantity+fmtPrice,['Product Name','Quantity','Price']));
	
      if (transactionNumber - (page-1) * 20 >= 20) then lc:=20
      else lc:=transactionNumber mod 20;
	  for i:=1 to lc do //20 entries each page
	  begin
	    readln(inp1,transactionID); readln(inp1,date); readln(inp1,productID);
	    readln(inp1,productName); readln(inp1,quantity); readln(inp1,price);
	  
        write(format(fmtID+fmtDate+fmtProductID,[transactionID,date,productID]));
        writeln(format(fmtName+fmtQuantity+fmtPrice,[productName,quantity,price]));

	  end;

	  writeln;
      writeln('New transaction : Press 1');
      writeln('Back to homepage : Press 2');

	  if (page - 1 <> transactionNumber div 20) then writeln('Next page : Press 3');

      repeat
	    write('Your choice : '); readln(choice);
	    if not( (choice = '1') or (choice = '2') or (choice = '3') and (page - 1 <> transactionNumber div 20) ) then
	    writeln('Invalid choice! Please enter again')
	    else break;
	  until false;
	
      if choice = '3' then inc(page);
	
    until choice <> '3';
    close(inp1);
    if choice = '1' then newTransaction;
  until choice = '2';
end;

procedure newTransaction;
var inp1,inp2,op1,op2:text;
transactionID,date,productID,productName,productType:string;
price,tprice:real;
quantity,stock,discount,a,b,err:longint;
tmp:string;
begin
  clrscr;
  writeln('New Transaction'); writeln;
  
  assign(inp1,'product.txt');
  repeat
    write('Product ID : '); readln(productID);
	reset(inp1);
    for i:=1 to productNumber do
	begin  
	  readln(inp1,tmp);
	  if tmp = productID then
	  begin
	    readln(inp1,productName); readln(inp1,productType);
		readln(inp1,price); readln(inp1,stock);
		read(inp1,discount);
		if discount = 1 then readln(inp1,a)
		else if discount = 2 then readln(inp1,a,b)
		else readln(inp1);
	    break;
	  end
	  else for j:=1 to 5 do readln(inp1,tmp);
	end;
    if tmp <> productID then writeln('Invalid product ID! Please enter again');
  until tmp = productID;
  close(inp1);
  
  if stock = 0 then 
  begin  
    writeln('Product out of stock!');
	writeln('Press enter to continue');
	readln;
    exit;
  end;
  
  repeat 
    write('Quantity : '); readln(tmp);
    val(tmp,quantity,err);
    if (err <> 0) then
    begin
      writeln('Invalid input! Please enter again');
      continue;
    end;
	if quantity = 0 then writeln('Quantity cannot be 0!')
	else if quantity > stock then 
	begin  
	  writeln('Current stock : ',stock);
	  writeln('Please enter again');
	end;
  until (quantity > 0) and (quantity <= stock);    
  
  if discount = 0 then
  begin  
    price := quantity * price;
  end
  else if discount = 1 then
  begin  
    price := quantity * price * (100 - a) / 100;
  end
  else if discount = 2 then
  begin  
    price := price * (quantity div (a + b) ) * a;
  end;
  
  repeat 
    write('Confirm? (Y/N)'); readln(choice);
  until (choice = 'Y') or (choice = 'N');
  
  if choice = 'Y' then
  begin
    inc(transactionNumber);
    str(transactionNumber,transactionID);
	for i:=1 to 8 - length(transactionID) do
	  transactionID := '0' + transactionID;
	date := DateTimeToStr(Now);

    assign(op1,'transactiontmp.txt'); rewrite(op1);

	writeln(op1,transactionID); writeln(op1,date);
	writeln(op1,productID); writeln(op1,productName);
	writeln(op1,quantity); writeln(op1,price:0:2);

	assign(inp2,'transaction.txt'); reset(inp2);
	for i:=1 to (transactionNumber - 1) * 6  do
	begin  
	  readln(inp2,tmp); writeln(op1,tmp);
	end;
	
	close(inp2); close(op1);
	erase(inp2);
	renamefile('transactiontmp.txt','transaction.txt');

    assign(inp1,'product.txt'); reset(inp1);
    assign(op1,'producttmp.txt'); rewrite(op1);
    while not eof(inp1) do
    begin
      readln(inp1,tmp); writeln(op1,tmp);
      if tmp = productID then
      begin
        for i:=1 to 3 do
        begin
          readln(inp1,tmp); writeln(op1,tmp);
        end;
        readln(inp1,stock); writeln(op1,stock - quantity);
      end;
    end;
    close(inp1); close(op1);
    erase(inp1);
    renamefile('producttmp.txt','product.txt');

	//update sale list
	assign(inp1,'sales.txt'); reset(inp1);
	assign(op1,'tmp.txt'); rewrite(op1);
	while not eof(inp1) do
	begin 
	  readln(inp1,tmp); writeln(op1,tmp);
	  if (tmp = productID) then
	  begin
	    readln(inp1,a); readln(inp1,tprice);
		writeln(op1,a + quantity); writeln(op1,tprice + price);
	  end
	  else 
	  begin
	    readln(inp1,tmp); writeln(op1,tmp);
		readln(inp1,tmp); writeln(op1,tmp);
	  end;
	end;
	close(inp1); close(op1);
	erase(inp1);
	renamefile('tmp.txt','sales.txt');
	
    writeln;
    writeln('Trasaction successful!');
    writeln('Transaction ID : ',transactionID);
    writeln('Date : ',date);
    writeln('Product ID : ',productID);
    writeln('Product Name : ',productName);
    writeln('Quantity : ',quantity);
    writeln('Price : ',price:0:2);
    writeln('Press enter to continue');
    readln;
  end;
end;

procedure manageUser;
var inp:text;
lc,page,n:longint;
tmpPassword,tmpUsername,choice2,choice1:string;
begin
  clrscr;
  writeln('1 - Manage staff account');
  writeln('2 - Manage customer account');
  repeat
    write('Your choice : '); readln(choice1);
	if (choice1 <> '1') and (choice1 <> '2') then writeln('Invalid choice! Please input again');
  until (choice1 = '1') or (choice1 = '2');
  
  repeat
    if choice1 = '1' then
    begin
      assign(inp,'staffAccount.txt');
	  n := staffNumber;
    end
    else
    begin
      assign(inp,'customerAccount.txt');
	  n := customerNumber;
    end;

    page := 1;

	reset(inp);
	repeat
      clrscr;
	  if (choice1 = '1') then writeln('Manage staff account')
	  else writeln('Manage customer account');
	  writeln('Page ',page); writeln;
	  writeln(format(fmtName+fmtName,['Username','Password']));
	
      if (n - (page-1) * 20 >= 20) then lc:=20
      else lc:=n mod 20;
	  
	  for i:=1 to lc do
	  begin 
	    readln(inp,tmpUsername); readln(inp,tmpPassword);
		writeln(format(fmtName+fmtName,[tmpUsername,tmpPassword]));
	  end;
	  
	  writeln;
	  writeln('1 - Add user');
	  writeln('2 - Manage user');
	  writeln('3 - Back to homepage');
	  if (page - 1 <> n div 20) then writeln('4 - Next Page');
	  repeat 
	    write('Your choice : ');
		readln(choice2);
		if (choice2 >= '1') and (choice2 <= '3') or (choice2 = '4') and (page - 1 <> n div 20) then break
		else writeln('Invalid choice! Please enter again');	
	  until false;
	  if choice2 = '4' then inc(page);
	until choice2 <> '4';
	close(inp);

    if choice2 = '1' then userRegister(ord(choice1[1]) - 49)
    else if choice2 = '2' then
    begin
      writeln;
      if choice1 = '1' then assign(inp,'staffAccount.txt')
      else assign(inp,'customerAccount.txt');
      repeat
        write('Enter username : ');
        readln(choice2);

        reset(inp);
        while not eof(inp) do
        begin
          readln(inp,tmpUsername);   readln(inp,tmpPassword);
          if tmpUsername = choice2 then break;
        end;
        if tmpUsername = choice2 then break
        else writeln('Invalid username! Please input again');
      until false;
      close(inp);

      staffUserDetail(ord(choice1[1])-49,choice2);
    end;

  until choice2 = '3';
	
end;

procedure staffUserDetail(x:longint;tusername:string);
var tmpUsername,tmpPassword,fileName,nextUser:string;
inp,op:text;
begin
  if x = 0 then fileName := 'staffAccount.txt'
  else fileName := 'customerAccount.txt';
  assign(inp,fileName);   reset(inp);

  while not eof(inp) do
  begin
    readln(inp,tmpUsername);
    readln(inp,tmpPassword);
    if tmpUsername = tusername then
    begin
      writeln('Username : ',tusername);
      writeln('Password : ',tmpPassword);
      break;
    end;
  end;
  if not eof(inp) then readln(nextUser)
  else nextUser := '';
  close(inp);
  
  writeln;
  writeln('1 - Change password');
  if (username <> tusername) then writeln('2 - Delete user');
  writeln;
  
  repeat
    write('Your choice : ');
    readln(choice);
    if (choice = '1') or (choice = '2') and (username <> tusername) then break
    else writeln('Invalid choice! Please enter again');
  until false;
  
  if choice = '1' then changePassword(x,tusername,tmpPassword)
  else if choice = '2' then
  begin 
    if x = 0 then dec(staffNumber) else dec(customerNumber);  
    assign(inp,fileName); reset(inp);
	assign(op,'tmp.txt'); rewrite(op);
	
	while not eof(inp) do
	begin  
	  readln(inp,tmpUsername); readln(inp,tmpPassword);
	  if tmpUsername = tusername then continue
	  else
	  begin  
	    writeln(op,tmpUsername); writeln(op,tmpPassword);
	  end;
	end;
	
	close(inp); close(op);
    erase(inp);
    renamefile('tmp.txt',fileName);
	
	if x = 1 then
	begin
	  assign(inp,'bookmark.txt'); reset(inp);
	  assign(op,'tmp.txt'); rewrite(op);
	  while not eof(inp) do
	  begin
	    readln(inp,tmpUsername);
		if (tmpUsername = tusername) then 
		repeat
		  readln(inp,tmpUsername);
		until (tmpUsername = nextUser) or eof(inp);
		writeln(op,tmpUsername);
	  end;
	  close(inp); close(op);
	  erase(inp);
	  renamefile('tmp.txt','bookmark.txt');
	end;
		
  end;
end;

procedure searchProduct(x:longint);
var tdiscount,tname,ttype:string;
begin
  clrscr;
  writeln('Leave the input blank if no filtering is needed'); writeln;
  writeln('Product List'); writeln;
  write('Name : '); readln(tname);
  write('Type : '); readln(ttype);
  writeln('Discount? ');
  writeln('0 - No discount');
  writeln('1 - X% off');
  writeln('2 - Buy X get X free');
  readln(tdiscount);
  write('Product out of stock? (Y/N) '); readln(choice);
  
  displayStock(x,tname,ttype,tdiscount,choice)
end;

procedure displayStock(x:longint;tname,ttype,tdiscount,tstock:string);
var inp,op:text;
count,page,lc:longint;
productID,productName,productType,price,tmpDiscount,discountType:string;
discount,a,b,stock:longint;
begin
  assign(inp,'product.txt'); reset(inp);
  assign(op,'tmp.txt'); rewrite(op);
  count := 0;
  for i:=1 to productNumber do
  begin 
    readln(inp,productID); readln(inp,productName); readln(inp,productType);
	readln(inp,price); readln(inp,stock); readln(inp,tmpDiscount);
	
	if ( (tname = '') or (pos(tname,productName) <> 0) )
	and ( (ttype = '') or (pos(ttype,productType) <> 0) )
	and ( (tdiscount = '') or (tmpDiscount[1] = tdiscount) )
	and ( (tstock = 'N') and (stock > 0) or (tstock = '')
       or (tstock = 'Y') and (stock = 0) ) then
	begin
	  inc(count);
	  writeln(op,productID); writeln(op,productName); writeln(op,productType);
	  writeln(op,price); writeln(op,stock); writeln(op,tmpDiscount);
	end;
  end;
  close(inp); close(op);
  
  repeat
    assign(inp,'tmp.txt'); reset(inp);
	page := 1;
	
	repeat
      clrscr;	
	  writeln('Product List'); writeln('Page ',page); writeln;
      write(format(fmtProductID+fmtName+fmtName,['Product ID','Product Name','Type']));
      writeln(format(fmtPrice+fmtQuantity+fmtName,['Price','Stock','Discount']));
	  
	  if count - (page-1) * 20 >= 20 then lc := 20
	  else lc := count mod 20;
	  for i:=1 to lc do 
      begin
        readln(inp,productID); readln(inp,productName); readln(inp,productType);
	    readln(inp,price); readln(inp,stock);
	    read(inp,discount);
        if discount = 0 then readln(inp)
	    else if discount = 1 then readln(inp,a)
	    else readln(inp,a,b);
	
    	if discount = 0 then discountType := 'N/A'
	    else if discount = 1 then
    	begin  
	      str(a,discountType);
		  discountType := discountType + '% off';
		end
		else
		begin  
		  discountType := 'Buy '+ chr(a+48) + ' get ' + chr(b+48) + ' free';
		end;
		str(stock,tstock);
	    write(format(fmtProductID+fmtName+fmtName,[productID,productName,productType]));
	    writeln(format(fmtPrice+fmtQuantity+fmtName,[price,tstock,discountType]));
	  end;
	  
	  writeln;
	  writeln('1 - Back to homepage');
	  if (page - 1 <> count div 20) then writeln('2 - Next page');
	  if x = 0 then
	  begin
	    writeln('3 - Add product');
	    writeln('4 - Manage product');
	  end
	  else writeln('3 - Add Bookmark');
	  writeln;
	  
	  repeat
	    write('Your choice : ');
		readln(choice);
		if (choice = '1') or (choice = '3') or (x = 0) and (choice = '4') 
		or (page-1 <> count div 20) and (choice = '2')
		then break
		else writeln('Invalid choice! Please enter again');
	  until false;
	  
	  if choice = '2' then inc(page);
	  
	until choice <> '2';
	close(inp);
	
  until choice <> '2'; 
  erase(inp);  
  
  if x = 0 then 
  begin
    if choice = '3' then newProduct
    else if choice = '4' then editStockDetail;
  end
  else if (x = 1) and (choice = '3') then addBookmark;
end;

procedure newProduct;
var productName,productType,tprice,tquantity,tmp,productID,discount:string;
price:real;
err,quantity,a,b:longint;
op:text;
begin
  clrscr;
  writeln('Add new product'); writeln;
  write('Product name : '); readln(productName);
  write('Product type : '); readln(productType);
  repeat
    write('Price : '); readln(tprice);
	val(tprice,price,err);
	if (err <> 0) then writeln('Invalid input! Please enter again')
	else break;
  until false;
  repeat
    write('Stock : '); readln(tquantity);
	val(tquantity,quantity,err);
	if (err <> 0) then writeln('Invalid input! Please enter again')
	else break;
  until false;
  writeln('Discount?');
  writeln('1 - X% off');
  writeln('2 - Buy X get X free');
  writeln('3 - No discount');
  repeat
    readln(discount);
	if not ( (discount = '1') or (discount = '2') or (discount = '3') ) then
	  writeln('Invalid choice! Please enter again')
	else break;
  until false;
  
  if discount = '1' then 
  begin  
    writeln('Input percentage off '); 
	repeat
	  readln(tmp);
	  val(tmp,a,err);
	  if (err <> 0) or (a <= 0) or (a > 100) then writeln('Invalid input! Please enter again')
	  else break;
	until false;
  end
  else if discount = '2' then
  begin 
    writeln('Input first integer ');
	repeat 
	  readln(tmp);
	  val(tmp,a,err);
	  if (err <> 0) or (a <= 0) then writeln('Invalid input! Please enter again')
	  else break;
	until false;
	
    writeln('Input second integer ');
	repeat 
	  readln(tmp);
	  val(tmp,b,err);
	  if (err <> 0) or (b <= 0) then writeln('Invalid input! Please enter again')
	  else break;
	until false;	
  end;
  
  repeat
    write('Confirm add product?(Y/N) '); readln(choice);
	if (choice <> 'Y') and (choice <> 'N') then writeln('Invalid choice! Please enter again')
	else break;
  until false;
  
  if choice = 'Y' then
  begin
    inc(productNumber);
	assign(op,'product.txt'); append(op);
	str(productNumber,productID);
	for i:=length(productID) + 1 to 5 do
	  productID := '0' + productID;
	writeln(op,productID); writeln(op,productName); writeln(op,productType);
	writeln(op,price:0:2); writeln(op,quantity);
	if (discount = '1') then writeln(op,'1 ',a)
	else if (discount = '2') then writeln(op,'2 ',a,' ',b)
	else writeln(op,0);
	close(op);
	
	assign(op,'sales.txt'); append(op);
	writeln(op,productID);
	close(op);
  end;
    
end;

procedure editStockDetail;
var productID,tmp,tdiscount:string;
price:real;
err,quantity,a,b,discount:longint;
inp,op:text;
v:boolean;
begin
  clrscr;
  assign(inp,'product.txt');
  repeat
    write('Enter product ID : '); readln(productID);
	reset(inp);
	v:=false;
	for i:=1 to productNumber do
	begin 
	  readln(inp,tmp);
	  if tmp = productID then
	  begin
	    v:=true;
		break;
	  end
	  else 
	  for j:=1 to 5 do readln(inp,tmp);
	end;
    
    if not v then writeln('Invalid input! Please enter again')
	else break;
  until false;
  
  reset(inp);
  assign(op,'tmp.txt'); rewrite(op);
  while not eof(inp) do
  begin
    readln(inp,tmp); writeln(op,tmp);
	if tmp = productID then
	begin 
	  readln(inp,tmp); writeln('Product name : ',tmp);
	  write('New name : '); readln(tmp);
	  writeln(op,tmp);
	  
	  readln(inp,tmp); writeln('Product type : ',tmp);
	  write('New type : '); readln(tmp);
	  writeln(op,tmp);
	  
	  readln(inp,tmp); writeln('Price : ',tmp);
	  repeat 
	    write('New price : '); readln(tmp);
		val(tmp,price,err);
		if (err = 0) and (price > 0) then break
		else writeln('Invalid input! Please enter again');
	  until false;
	  writeln(op,tmp);
	  
	  readln(inp,tmp); writeln('Stock : ',tmp);
	  repeat
	    write('New stock : '); readln(tmp);
		val(tmp,quantity,err);
		if (err = 0) and (quantity > 0) then break
		else writeln('Invalid input! Please enter again');
      until false;
	  writeln(op,tmp);
	  
	  read(inp,discount);
	  write('Discount : ');
	  if discount = 0 then writeln('N/A')
	  else if discount = 1 then
	  begin
	    readln(inp,a);  writeln(a,'% off');
	  end
	  else if discount = 2 then
	  begin
	    readln(inp,a,b);  writeln('Buy ',a,' get ',b,' free');
	  end;
	  
	  writeln('New Discount : ');
      writeln('1 - X% off');
      writeln('2 - Buy X get X free');
	  writeln('3 - No discount');
	  repeat
		readln(tdiscount);
		if not ( (tdiscount = '1') or (tdiscount = '2') or (tdiscount = '3') )
		  then writeln('Invalid choice! Please enter again')
	    else break;
      until false;
  
      if tdiscount = '1' then 
      begin  
        writeln('Input percentage off '); 
	    repeat
	      readln(tmp);
	      val(tmp,a,err);
	      if (err <> 0) or (a <= 0) or (a > 100) then writeln('Invalid input! Please enter again')
	      else break;
	    until false;
		writeln(op,tdiscount,' ',a);
	  end
	  else if tdiscount = '2' then
	  begin 
        writeln('Input first integer ');
	    repeat 
	      readln(tmp);
	      val(tmp,a,err);
	      if (err <> 0) or (a <= 0) then writeln('Invalid input! Please enter again')
	      else break;
	    until false;
	
        writeln('Input second integer ');
	    repeat 
	      readln(tmp);
	      val(tmp,b,err);
	      if (err <> 0) or (b <= 0) then writeln('Invalid input! Please enter again')
	        else break;
	    until false;	
		writeln(op,tdiscount,' ',a,' ',b);
	  end
	  else if tdiscount = '3' then writeln(op,0);
    end
	else
	begin
	  readln(inp,tmp); writeln(op,tmp);
	  readln(inp,tmp); writeln(op,tmp);
	  readln(inp,tmp); writeln(op,tmp);
	  readln(inp,tmp); writeln(op,tmp);
	  readln(inp,tmp); writeln(op,tmp);
	end;
  end;
  close(inp); close(op);
  erase(inp);
  renamefile('tmp.txt','product.txt');
end;

procedure saleAnalysis;
var quantity:array[1..10000] of longint;
id:array[1..10000] of string;
price:array[1..10000] of real;
tmp,page,lc:longint;
treal:real;
tmp1,tmp2:string;
inp,op:text;
begin
  clrscr;
  assign(inp,'sales.txt'); reset(inp);
  for i:=1 to productNumber do
  begin
    readln(inp,id[i]); readln(inp,quantity[i]); readln(inp,price[i]);
  end;
  close(inp);
  
  writeln('Sale Analysis'); writeln;
  writeln('1 - sort by quantity');
  writeln('2 - sort by price');
  repeat
    write('Your choice : ');
	readln(choice);
	if (choice = '1') or (choice = '2' ) then break
	else writeln('Invalid input! Please enter again');
  until false;
  
  if choice = '1' then
  begin
    for i:=1 to productNumber - 1 do
	  for j:=1 to productNumber - i do
	    if quantity[j] < quantity[j+1] then
		begin
		  tmp := quantity[j]; quantity[j] := quantity[j+1]; quantity[j+1] := tmp;
		  tmp1 := id[j]; id[j] := id[j+1]; id[j+1] := tmp1;
		  treal := price[j]; price[j] := price[j+1]; price[j+1] := treal;
		end;
  end
  else if choice = '2' then
  begin
    for i:=1 to productNumber - 1 do
	  for j:=1 to productNumber - i do
	    if price[j] < price[j+1] then
		begin
		  tmp := quantity[j]; quantity[j] := quantity[j+1]; quantity[j+1] := tmp;
		  tmp1 := id[j]; id[j] := id[j+1]; id[j+1] := tmp1;
		  treal := price[j]; price[j] := price[j+1]; price[j+1] := treal;
		end;
  end;
  
  page := 1;
  repeat
    clrscr;
    writeln('Page ',page);
	writeln(format(fmtID+fmtQuantity+fmtPrice,['ID','Quantity','Price']));
    if page = (productNumber-1) div 20 + 1 then lc := productNumber mod 20
	else lc := 20;
	for i:=(page-1)*20 + 1 to (page-1)*20 + lc do
	begin
	  str(quantity[i],tmp1);
	  writeln(format(fmtID+fmtQuantity,[id[i],tmp1]),price[i]:0:2);
	end;
	writeln;
	writeln('1 - Back to HomePage');
	if page <> (productNumber-1) div 20 + 1 then writeln('2 - Next Page');
	repeat
	  write('Your choice : ');
	  readln(choice);
	  if (choice = '1') or (page <> (productNumber-1) div 20 + 1) and (choice = '2') then break
	  else writeln('Invalid choice! Please enter again');
	until false;
	if choice = '2' then inc(page);
  until choice = '1';
end;

procedure addBookmark;
var productID,tmp:string;
inp,op:text;
begin
  assign(inp,'product.txt'); 
  repeat 
    write('Enter Product ID : ');
	readln(productID);
	reset(inp);
	while not eof(inp) do
	begin
	  readln(inp,tmp);
	  if tmp = productID then break;
	end;
	if tmp = productID then break
	else writeln('Invalid input! Please enter again');
  until false;
  close(inp);
  
  assign(inp,'bookmark.txt'); reset(inp);
  assign(op,'tmp.txt'); rewrite(op);
  repeat 
	readln(inp,tmp); writeln(op,tmp);
  until tmp = username;
  writeln(op,productID);
  while not eof(inp) do
  begin
    readln(inp,tmp); writeln(op,tmp);
  end;
  close(inp); close(op);
  erase(inp);
  renamefile('tmp.txt','bookmark.txt');
end;

procedure customerHomepage;
begin
  repeat
    clrscr;
    writeln('Welcome ',username,'!'); writeln;
    for i:= 1 to 40 do write('*'); writeln; writeln;
    writeln('1 - Display Product');
    writeln('2 - Manage Bookmark');
    writeln('3 - Change Password');
    writeln('4 - Logout');
    writeln;
    repeat
      write('Your choice : ');
   	  readln(choice);
	  if (choice >= '1') and (choice <= '4') then break
	  else writeln('Invalid choice! Please enter again');
    until false;
	
	if choice = '1' then searchProduct(1)
	else if choice = '2' then customerBookmark
	else if choice = '3' then changePassword(1,username,password)
	else if choice = '4' then break;
  until false;
  
end;

procedure customerBookmark;
var inp,op,inp1:text;
tmp,tProductID,discountType:string;
t:array[1..5] of string;
count,lc,page,discount,a,b:longint;
begin
  count := 0;
  assign(inp,'bookmark.txt'); reset(inp);
  assign(op,'tmp.txt'); rewrite(op);
  while not eof(inp) do
  begin
    readln(inp,tmp);
	if tmp = username then break;
  end;
  if not eof(inp) then
  begin
    readln(inp,tmp);
	while not eof(inp) and (length(tmp) = 5) do
	begin
	  inc(count); writeln(op,tmp); readln(inp,tmp);
	end;
	if eof(inp) then
    begin
   	  writeln(op,tmp); inc(count);
	end;
  end;
  close(inp); close(op);
  
  assign(inp,'tmp.txt'); reset(inp);
  assign(inp1,'product.txt'); reset(inp1);
  page := 1;
  repeat
    clrscr;
	writeln('Page ',page);
	write(format(fmtProductID+fmtName+fmtName,['Product ID','Product Name','Type']));
    writeln(format(fmtPrice+fmtQuantity+fmtName,['Price','Stock','Discount']));
	
    if (count-1) div 20 + 1 = page then lc := count mod 20
	else lc := 20;
	for i:=1 to lc do
	begin
	  readln(inp,tProductID); reset(inp1);
	  while not eof(inp1) do
	  begin
	    readln(inp1,tmp);
		if tmp = tProductID then 
		begin
		  write(format(fmtProductID,[tmp]));
		  for j:=1 to 4 do readln(inp1,t[j]);
		  write(format(fmtName+fmtName+fmtPrice+fmtQuantity,[t[1],t[2],t[3],t[4]]));
		  read(inp1,discount);
          if discount = 0 then readln(inp1)
	      else if discount = 1 then readln(inp1,a)
	      else readln(inp1,a,b);
    	  if discount = 0 then discountType := 'N/A'
	      else if discount = 1 then
    	  begin  
	        str(a,discountType);
		    discountType := discountType + '% off';
		  end
		  else
		  begin  
		    discountType := 'Buy '+ chr(a+48) + ' get ' + chr(b+48) + ' free';
	      end;
		  writeln(format(fmtName,[discountType]));
		  break;
		end; 
	  end;
    end;
	writeln;
	writeln('1 - Delete Bookmark');
	writeln('2 - Back to HomePage');
	if (page < ((count-1) div 20 + 1)) then writeln('3 - Next Page');
	
	repeat
	  write('Your choice : '); 
	  readln(choice);
	  if (choice = '1') or (choice = '2') or (choice = '3') and (page < ((count-1) div 20 + 1)) then break
	  else writeln('Invalid input! Please enter again');
	until false;
	if choice = '3' then inc(page);
  until choice <> '3';
  close(inp1); close(inp);  
  if choice = '1' then deleteBookmark;
  erase(inp);
end;

procedure deleteBookmark;
var inp,op:text;
tProductID,tmp:string;
begin
  writeln('Delete Bookmark'); writeln;
  assign(inp,'tmp.txt'); 
  repeat
    write('Enter product ID : '); readln(tProductID);
	reset(inp);
	while not eof(inp) do
	begin
	  readln(inp,tmp);
	  if tmp = tProductID then break;
	end;
	if tmp <> tProductID then writeln('Invalid input! Please enter again')
	else break;
  until false;
  close(inp);
  
  assign(inp,'bookmark.txt'); reset(inp);
  assign(op,'t.txt'); rewrite(op);
  while not eof(inp) do
  begin
    readln(inp,tmp); writeln(op,tmp);
	if tmp = username then break;
  end;
  readln(inp,tmp);
  while (tmp <> tProductID) do
  begin
    writeln(op,tmp); readln(inp,tmp);
  end;
  while not eof(inp) do
  begin
    readln(inp,tmp); writeln(op,tmp);
  end;
  close(inp); close(op);
  erase(inp);
  renamefile('t.txt','bookmark.txt');
end;

begin
  init;
  loginPage;
  resetCount;
end.
