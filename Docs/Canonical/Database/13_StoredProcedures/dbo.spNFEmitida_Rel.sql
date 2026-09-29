SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spNFEmitida_Rel
	@Data_Inicial datetime,
	@Data_Final	   datetime
	
AS




select  
	Codigo, Numero,sum(Valor_ARP)Valor ,
	Dt_Fatura Data_NF,P.Num_Proc [Job],
	[dbo].[fBusca_TipoDocCliente]('N',Num_Proc,3) Sales_Order, 
	[dbo].[fBusca_TipoDocCliente]('N',Num_Proc,1)  PO_Number,G.CUIT CNPJ,
	Razao_Social,Endereco,Cidade,G.Obs,G.ID_Fat    
from Fatura_ARG G with (nolock)
	Join Fatura_ARG_Det P with(nolock) on G.ID_Fat = P.ID_Fat 
Where
	Dt_Fatura between @Data_Inicial and @Data_Final 
Group by Codigo, Numero,Dt_Fatura,num_proc,Cuit,Razao_Social,Endereco,Cidade,obs,G.ID_FAT


GO
