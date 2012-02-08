<html>  
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
<meta http-equiv="Pragma" content="no-cache" />  
<meta http-equiv="Expires" content="-1" />  
<meta http-equiv="Cache-Control" content="no-cache" />  
<title>Sigma Grid Tutorial 1</title>  
  
<link rel="stylesheet" type="text/css" href="grid/gt_grid.css" />  
<script type="text/javascript" src="grid/gt_msg_en.js"></script>
<script type="text/javascript" src="grid/gt_const.js"></script>
<script type="text/javascript" src="grid/gt_grid_all.js"></script>
 
<script type="text/javascript" >  
<!-- All the scripts will go here  --> 
var data1 = [
 
{serialNo:"010-0",country:"MA",employee:"Jerry",customer:"Keith",order2005:50,order2006:57,order2007:80,order2008:46,lastDate:"2008-10-02"},
{serialNo:"010-1",country:"SP",employee:"Charles",customer:"Marks",order2005:79,order2006:37,order2007:40,order2008:90,lastDate:"2008-04-24"},
{serialNo:"010-2",country:"SP",employee:"Vincent",customer:"Harrison",order2005:91,order2006:75,order2007:31,order2008:40,lastDate:"2008-02-17"},
{serialNo:"020-3",country:"RA",employee:"Edward",customer:"Sidney",order2005:61,order2006:31,order2007:80,order2008:47,lastDate:"2008-10-16"}
 
];
 
var dsOption= {
    fields :[
        {name : "serialNo"},
        {name : "country"},
        {name : "customer"  },
        {name : "employee"},
        {name : 'order2005' ,type: 'float' },
        {name : 'order2006' ,type: 'float' },
        {name : 'order2007' ,type: 'float' },
        {name : 'order2008' ,type: 'float' },
        {name : 'lastDate' ,type:'date'  }    
    ],
    recordType : 'object',
    data: data1
} 
 
var colsOption = [
     {id: 'serialNo' , header: "Order No" , width :60 },
     {id: 'employee' , header: "Employee" , width :80  },
       {id: 'country' , header: "Country" , width :70  },
       {id: 'customer' , header: "Customer" , width :80  },
       {id: 'order2005' , header: "2005" , width :60},
       {id: 'order2006' , header: "2006" , width :60},
       {id: 'order2007' , header: "2007" , width :60},
       {id: 'order2008' , header: "2008" , width :60},
       {id: 'lastDate' , header: "Delivery Date" , width :100}
       
];
 
 
var gridOption={
    id : "grid1",
    container : 'grid1_container', 
    dataset : dsOption ,
    columns : colsOption
};
 
var mygrid=new Sigma.Grid(gridOption);
Sigma.Util.onLoad( Sigma.Grid.render(mygrid) );
  
</script>  
</head>  
  
<body>  
<!-- grid container. -->  
<div id="grid1_container" style="width:700px;height:300px">  
</div>  
  
 </body>  
</html>