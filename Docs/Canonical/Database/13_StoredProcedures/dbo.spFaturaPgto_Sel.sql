SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFaturaPgto_Sel]
		@FatCod Varchar(17)

AS

/* Stored Verifica se houve pagamento da fatura  */


select 
	* 
from 
	item_fat FAT With(nolock)
	Left Join vwcxas CXA With(nolock) on fat.num_proc=cxa.num_proc_hia and fat.cd_tp_tx=cxa.cd_tp_Tx and fat.dc=cxa.dc_hia
	left join Tipo_Taxa T on FAT.Cd_Tp_Tx = T.Cd_Tp_Tx
where 
	fatcod=@fatcod
	and cxa.num_proc_hia is null 
	and T.CD_AX_Resultado <> '000.1'
	--- DESABILITADO POR ANDERSON OLIVEIRA EM 28/08/2013 - Solicitação Alex/Osney/Marcos
	-- Habilidado novamente em 30/08/2013
	
	--Incluido para nao considerar os impostos
	--Cadu 6/4 as 14:51h
	
GO
