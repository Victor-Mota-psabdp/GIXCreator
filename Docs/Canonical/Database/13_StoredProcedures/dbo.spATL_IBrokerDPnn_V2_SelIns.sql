SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_IbrokerDPnn_SelIns 19,'IMFMC201503001BR'
CREATE procedure [dbo].[spATL_IBrokerDPnn_V2_SelIns](
 @ID_ITDI bigint,
 @ID_View bigint
)

as



Declare	@01	varchar(4)
Declare	@02	varchar(15)
Declare	@03	varchar(4)
Declare	@04	varchar(16)
Declare	@05	varchar(201)


Declare @TableProduto Table(
							Cd_Pedido int,
							CD_Produto int,
							Item varchar(6),
							Lote varchar(30)
							)
						
Declare @z Int

select @z=Qty_Item from IBROKER_CAP2_V2
where ID = @ID_View
select 
@02 = JOB
from
IBROKER_CAPI_V2
where ID = @ID_View
--select @Processo,@cd_pedido,@cd_produto,@Item,@Lote
Declare  @x int
set @x=1
Declare @xIDnn int 
Declare @yIDnn int 
Declare  @t int

set @xIDnn = 0

While @z >= @x
	Begin

		set @yIDnn = 0
		set @xIDnn = 0
		set @t=1
		Declare @Descricao varchar(max)
			
			select 
				@xIDnn=len(replace(replace(ltrim(rtrim(Full_Description)), CHAR(13), CHAR(32)), CHAR(10), CHAR(32))),
				@Descricao = replace(replace(ltrim(rtrim(Full_Description)), CHAR(13), CHAR(32)), CHAR(10), CHAR(32)) 
			from 
				IBROKER_Item_V2
			where ID = @ID_View and ID_Item = @x

		WHILE @xIDnn>0
		begin
		--[05]				
			if @xIDnn >= 201
			begin
					select @05=substring(@Descricao,@yIDnn,@yIDnn +201)

				set  @yIDnn = @yIDnn +201 
			end
			else
				begin 
					select @05=right(@Descricao,@xIDnn + 1)
				end

		set	@01	=	dbo.PreencheStringV2('DP'+right('00'+cast(@t as varchar(10)),2),4,' ')
		set	@02	=	dbo.PreencheStringV2(@02,15,' ')
		set	@03	=	dbo.PreencheStringV2(@x,4,'0') 
		set	@04	=	dbo.PreencheStringV2('',16,' ') 
		--set	@05	=	dbo.PreencheStringV2(@05,201,' ')
		set	@05	=	dbo.PreencheStringDireita(@05,201,' ')
		
		
		insert dbo.IBROKER_DPnn 
		Select 
		@ID_ITDI,
		@x,
		@t,
		@01	[01],
		@02	[02],
		@03	[03],	
		@04	[04],
		@05	[05]
		set @t=@t+1
		set @xIDnn = @xIDnn - 201
		end
		set @x=@x+1
	END
GO
