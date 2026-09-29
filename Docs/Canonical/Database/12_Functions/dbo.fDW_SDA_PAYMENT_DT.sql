SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select [dbo].[fDW_SDA_PAYMENT_DT]('SDA')
CREATE function [dbo].[fDW_SDA_PAYMENT_DT]
(
	@Nome_Tp_Tx	Varchar(50)
)

RETURNS Datetime

BEGIN
	 Declare @Resultado Datetime

	 set @Resultado =(
				select 
					top 1 convert(datetime,CXA.dt_pgto_Rcto_hia,105)
				from 
					vwcxas CXA with(nolock)
					Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_Tx
				Where
					TT.nome_tp_tx = 'SDA 1 - BDP'
					and CXA.dc_hia='D'
					and convert(datetime,CXA.dt_pgto_Rcto_hia,105) <= convert(datetime,getdate(),105)
				order by 
					convert(datetime,CXA.dt_pgto_Rcto_hia,105) desc)

	 RETURN @Resultado
END


--select * from Tipo_Taxa where nome_tp_tx like 'SDA%'


--select * from vwcxas where cd_tp_tx in (
--select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'SDA%')
--and convert(datetime,dt_pgto_Rcto_hia,105) >	getdate() -31	
GO
