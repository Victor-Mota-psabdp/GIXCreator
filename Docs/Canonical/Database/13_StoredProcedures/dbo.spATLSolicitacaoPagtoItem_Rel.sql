SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATLSolicitacaoPagtoItem_Rel]-- spATLSolicitacaoPagtoItem_Rel '2021-08-13','2021-08-15'
 @DataInicial Datetime,  
 @dataFinal Datetime  
As  
  
select   
 SP.ID RN,  
 dt_ins  [Register Date],  
 Dt_Vcto [Due Date], 
 tc.Nome_Tp_Doc [Method Payment],  
 PP.apelido [Debitor],  
 SPI.Num_Proc [Job Number],
 SPI.Cd_Tp_Moeda [Currency],
 cast(SPI.Par_Moeda as varchar(10)) [Exc Rate],
 SPI.Vlr_Ref [Original Currency - Value],
 SPI.Vlr_Pgto_Rcto [BRL Value] ,
 US.Nome_Usuario [Requester]
  
from   
 Sol_Pgto_Cta_Cte SP with(nolock)  
 Join Sol_Pgto_Cta_Cte_Item SPI with(nolock) on SPI.ID=SP.ID
 join Pessoa PP with(nolock) on PP.cd_pes=Cd_Cred_Dev  
 Join Tipo_Documento TC with(nolock) on tc.Cd_Tp_Doc=SP.Cd_Tp_Doc  
 Join Usuario Us with(nolock) on US.Cd_Usuario=SP.Cd_Solicitante  
 Left Join Usuario MG with(nolock) on MG.cd_usuario = SP.Cd_Gerente  
 Left Join Usuario DR with(nolock) on dR.Cd_Usuario = sp.Cd_Diretor
Where  
  Dt_Vcto  between @DataInicial and @dataFinal   


GO
