SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_SOLAS_REL]--'EMATL201601001BR',''
(
	@Num_Proc varchar(16),
	@USuario varchar(250)
)

as

select	
	P.Nome_Raz_Soc Shipper,
	C.Nome_Tp_Carga	,
	LEM.Num_Proc ,
	[dbo].[Qty_Container](LEM.Num_Proc) qty,
	--@Usuario [User],
	(select max(Nome_Responsavel_VGM) from Container_Additional_Info where num_proc= @Num_Proc) [User],
	LEM.Booking_Number,
	dbo.fbusca_docs_po_modal(LEM.Num_Proc,'1')	Shipper_Reference
from vwHouse_Exp LEM with(nolock)
	left join Pessoa P on P.Cd_Pes = LEm.Cd_Export
	left join Tipo_Carga C on c.Cd_Tp_Carga = Lem.Cd_Tp_Carga
where 
	LEM.Num_Proc = @Num_Proc
	

GO
