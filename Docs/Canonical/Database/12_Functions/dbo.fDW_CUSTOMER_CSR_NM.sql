SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spINTUserDow]
CREATE function [dbo].[fDW_CUSTOMER_CSR_NM]
(
	@Num_Proc Varchar(16)	
			
)
returns varchar(50)

AS 

BEGIN
	Declare @Valor varchar(50)

	BEGIN
		set @valor=Isnull((
			select Top 1 isnull(US.Nome_usuario, isnull(PO.Nome_Usuario,'NO REF#')) from Pedido PD with(nolock)
			left join Usuario_Cliente US with(nolock) on PD.Cd_USERID=US.Cd_Usuario and US.Nome_Usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
			--Left join Usuario_Cliente CSR with(nolock) on cd_csrid=CSR.cd_usuario and csr.nome_usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
			Left Join Usuario_Cliente PO with(nolock) on PD.PO_Responsible=PO.Cd_Usuario and  PO.Nome_Usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
			Left Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.Cd_pedido
			where Num_Proc=@Num_Proc
			),'NO REF#')
	END
	
	return @valor
END







GO
