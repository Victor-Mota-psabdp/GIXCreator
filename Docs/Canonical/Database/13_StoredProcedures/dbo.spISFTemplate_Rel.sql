SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spISFTemplate_Rel]--'EMATL201608017BR'
(			
	@Processo Varchar(16)
)
AS

select
MAWB [MBL],
Booking_Number [Booking_Number],
HAWB,
txtShipper,
txtConsignee,
Armador.Nome_Armador 	Armador,
Vessel,
LO.Nome_Local		[Origin],
LD.Nome_Local		[Destination],
LDF.Nome_Local		[Final_Destination],
Viagem Voyage, --inclui o nome novo Viagem
Convert(varchar(10),ETD,103) [ETD],
Convert(varchar(10),ETA,103) [ETA],
Convert(varchar(10),Original_ETA,103) [Original_ETA],
dbo.qty_container (Hou.Num_Proc) [Qtd_Container],
dbo.fBusca_Containers_TP (Hou.Num_Proc) [Tipo_Container],
Descr.Descr,
dbo.fBusca_Volumes_NCM (HOU.Num_Proc) NCM,
dbo.fBusca_DescrContainers_EM(Hou.Num_Proc,'Container') [Num_Container],
dbo.fBusca_DescrContainers_EM(Hou.Num_Proc,'Lacre') [Num_Lacre],
dbo.fBusca_DescrContainers_EM(Hou.Num_Proc,'Peso') [Peso_Bruto_EM],
Qtd_Vol [Pecas]
from vwHouse_Exp HOU with(nolock)
Left Outer Join Nature_Goods Descr	with(nolock) on HOU.Num_proc = Descr.Num_Proc
Left Outer Join Armador		Armador	with(nolock) on HOU.cd_armador = Armador.cd_Armador 
Left Outer Join altera_bl AL		with(nolock) on Hou.Num_Proc = AL.num_proc
Join Localidade LO					with(nolock) on LO.cd_local = HOU.Cd_Org
Join Localidade LD					with(nolock) on LD.cd_local = HOU.Cd_Dst
Join Localidade LDF					with(nolock) on LDF.cd_local = HOU.Cd_DstFinal
where HOU.Num_Proc = @Processo
GO
