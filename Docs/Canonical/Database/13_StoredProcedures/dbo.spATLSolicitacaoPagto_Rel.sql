SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Sol_Pgto_Cta_Cte where ID = '8221760'
--Payment request creation date between Start and end date
--changed the status to be equal: spSolPgtoCtaCte_Sel 24/08/2021 09:01
CREATE  Procedure [dbo].[spATLSolicitacaoPagto_Rel]-- spATLSolicitacaoPagto_Rel '2021-08-13','2021-08-15'
 @DataInicial Datetime,  
 @dataFinal Datetime  
As  
  
--Ticket 100-227309  
	select 
		SP.ID RN,
		Case when SP.Doc_Number is not null then SP.Doc_Number else 'SP'+convert(varchar(50),SP.ID) end [Invoice Oracle],		  
		SP.dt_ins  [Register Date],  
		SP.Dt_Vcto [Due Date], 
  
		PP.apelido [Debitor],  
		SP.Vlr_Doc [Value],
		tc.Nome_Tp_Doc [Method Debit],  
		SP.InfBanco [Bank Info],  
		--case  
		-- When isnull(SP.Status_Aprovacao,'')='A' then 'Approved'  
		-- When isnull(SP.Status_Aprovacao,'') ='D' then 'Denied'  
		-- else 'Open'  
		--End [Status], 
		(CASE WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 1 THEN 'Created' 
		WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 0 THEN 'Canceled' 
		WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 1 THEN 'Approved'
		WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 0 THEN 'Canceled' 
		WHEN (SP.Status_Aprovacao = 'D' Or SP.Status_Aprovacao = 'E')
		AND SP.Status = 1 or SP.Status = 0 THEN 'Rejected' END) AS [Status], 
		US.Nome_Usuario [Requester],  
		MG.Nome_Usuario [Manager],  
		dr.Nome_Usuario [Director] 
 
  
		--Leandro 100-355731
		,[dbo].[FBusca_Sol_Pgto_Cta_Cte_Item]( SP.ID,'Currency') [Currency],
		--,SPI.Cd_Tp_Moeda [Currency],
		[dbo].[FBusca_Sol_Pgto_Cta_Cte_Item]( SP.ID,'Exc Rate') [Exc Rate]
		--cast(SPI.Par_Moeda as varchar(10)) [Exc Rate]
  
	from Sol_Pgto_Cta_Cte SP with(nolock)
	--Join Sol_Pgto_Cta_Cte_Item SPI with(nolock) on SPI.ID=SP.ID
	join Pessoa PP with(nolock) on PP.cd_pes=Cd_Cred_Dev  
	Join Tipo_Documento TC with(nolock) on tc.Cd_Tp_Doc=SP.Cd_Tp_Doc  
	Join Usuario Us with(nolock) on US.Cd_Usuario=SP.Cd_Solicitante  
	Left Join Usuario MG with(nolock) on MG.cd_usuario = SP.Cd_Gerente  
	Left Join Usuario DR with(nolock) on dR.Cd_Usuario = sp.Cd_Diretor
	Where  
	Dt_Vcto  between @DataInicial and @dataFinal   



GO
