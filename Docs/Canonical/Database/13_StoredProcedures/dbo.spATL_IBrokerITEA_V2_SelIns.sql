SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_IBrokerITEA_V2_SelIns 845,1
CREATE procedure [dbo].[spATL_IBrokerITEA_V2_SelIns](
 @ID_ITDI bigint,
 @ID_View bigint
)

as

Declare	@01	varchar(4)
Declare	@02	varchar(15)
Declare	@03	varchar(20)
Declare	@04	varchar(15)
Declare	@05	varchar(2)
Declare	@06	varchar(12)
Declare	@07	varchar(12)
Declare	@08	varchar(1)
Declare	@09	varchar(5)
Declare	@10	varchar(10)
Declare	@11	varchar(2)
Declare	@12	varchar(1)
Declare	@13	varchar(4)
Declare	@14	varchar(4)
Declare	@15	varchar(3)
Declare	@16	varchar(3)
Declare	@17	varchar(10)
Declare	@18	varchar(3)
Declare	@19	varchar(9)
Declare	@20	varchar(9)
Declare	@21	varchar(4)
Declare	@22	varchar(6)
Declare	@23	varchar(10)
Declare	@24	varchar(3)
Declare	@25	varchar(9)
Declare	@26	varchar(9)
Declare	@27	varchar(4)
Declare	@28	varchar(6)
Declare	@29	varchar(10)
Declare	@30	varchar(3)
Declare	@31	varchar(9)
Declare	@32	varchar(9)
Declare	@33	varchar(4)
Declare	@34	varchar(6)
Declare	@35	varchar(4)

Declare @x Int
Declare @y Int
set @y = 1
select @x=Qty_Item from IBROKER_CAP2_V2
where ID = @ID_View

select 
@02 = JOB,
@15= Code_Origin_Country
from
IBROKER_CAPI_V2
where ID = @ID_View
select 
	@13 = Ibroker,
	@14 = Ibroker
from IBROKER_Pessoa_V2 where ID = @ID_View and Tipo =  'S'
while @x >= @y
	Begin

		Select 

		@03=Product_ID,
		@04=Qty,
		@05=UOM_Siscomex,
		@06=Net_Weight,
		@07=Unit_Price,
		@17=NCM,
		@22=ID_RM,
		@23=Num_Pedido,
		@35=Item
		from 
		IBROKER_Item_V2
		where ID = @ID_View and ID_Item = @y

			
		set	@01	=	dbo.PreencheStringV2('ITEA',4,'	')
		set	@02	=	dbo.PreencheStringV2(@02,15,' ')
		set	@03	=	dbo.PreencheStringV2(@03,20,' ') --Product ID
		set	@04	=	dbo.PreencheStringV2(@04,15,'0') --Quantity
		set	@05	=	dbo.PreencheStringV2(@05,2,' ')--UOM
		set	@06	=	dbo.PreencheStringV2(@06,12,'0')--Net Weight
		set	@07	=	dbo.PreencheStringV2(@07,12,'0')--Unit Price
		set	@08	=	dbo.PreencheStringV2('1',1,' ')
		set	@09	=	dbo.PreencheStringV2('0.00',5,'0')
		set	@10	=	dbo.PreencheStringV2('0.00',10,'0')
		set	@11	=	dbo.PreencheStringV2('',2,' ')
		set	@12	=	dbo.PreencheStringV2('1',1,' ')
		set	@13	=	dbo.PreencheStringV2(@13,4,' ')--Vendor
		set	@14	=	dbo.PreencheStringV2(@13,4,' ')--Vendor
		set	@15	=	dbo.PreencheStringV2(@15,3,' ')--Origin Country
		set	@16	=	dbo.PreencheStringV2(@15,3,' ')--Origin Country
		set	@17	=	dbo.PreencheStringV2(@17,10,' ')
		set	@18	=	dbo.PreencheStringV2('',3,' ')
		set	@19	=	dbo.PreencheStringV2('',9,' ')
		set	@20	=	dbo.PreencheStringV2('',9,' ')
		set	@21	=	dbo.PreencheStringV2('',4,' ')
		set	@22	=	dbo.PreencheStringV2(@22,6,' ')
		set	@23	=	dbo.PreencheStringV2(@23,10,' ')
		set	@24	=	dbo.PreencheStringV2('',3,' ')
		set	@25	=	dbo.PreencheStringV2('',9,' ')
		set	@26	=	dbo.PreencheStringV2('',9,' ')
		set	@27	=	dbo.PreencheStringV2('',4,' ')
		set	@28	=	dbo.PreencheStringV2('',6,' ')
		set	@29	=	dbo.PreencheStringV2('',10,' ')
		set	@30	=	dbo.PreencheStringV2('',3,' ')
		set	@31	=	dbo.PreencheStringV2('',9,' ')
		set	@32	=	dbo.PreencheStringV2('',9,' ')
		set	@33	=	dbo.PreencheStringV2('',4,' ')
		set	@34	=	dbo.PreencheStringV2('',6,' ')
		set	@35	=	dbo.PreencheStringV2(@y,4,'0')--Item

		insert dbo.IBROKER_ITEA 
		Select 
		@ID_ITDI,
		@y,
		@01	[01],
		@02	[02],
		@03	[03],	
		@04	[04],
		@05	[05],
		@06	[06],	
		@07	[07],
		@08	[08],
		@09	[09],	
		@10	[10],	
		@11	[11],	
		@12	[12],
		@13	[13],
		@14	[14],
		@15	[15],
		@16	[16],
		@17	[17],
		@18	[18],	
		@19	[19],	
		@20	[20],	
		@21	[21],	
		@22	[22],	
		@23	[23],	
		@24	[24],	
		@25	[25],	
		@26	[26],	
		@27	[27],	
		@28	[28],	
		@29	[29],	
		@30	[30],	
		@31	[31],	
		@32	[32],	
		@33	[33],	
		@34	[34],	
		@35	[35]
		set @y=@y+1

	End

GO
