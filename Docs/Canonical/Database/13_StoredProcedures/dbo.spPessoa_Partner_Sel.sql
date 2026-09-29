SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPessoa_Partner_Sel]--'IMCSR201711488BR'
(
	@num_proc as varchar(16)	
)
as

	
declare @ID_PD int

set @ID_PD  = (select Campo_Dados from Campo_Processo where Id_Campo = 143 and Num_Proc = @num_proc)

if @ID_PD = 3

	SELECT  
		PS.Apelido dados, 
		PS.Cd_Pes, 
		PS.Nome_Raz_Soc, 
		PS.Num_CPF_CNPJ,
		B.Nome_BDP_Produto
	FROM  dbo.Pessoa PS with (nolock)
		JOIN dbo.Campo_Pessoa PL with (nolock) ON PL.Cd_Pes = PS.Cd_Pes and PL.Id_Campo = 17
		join BDP_Produto B on B.ID_PD = PL.Campo_Dados	 
	where 
		PS.Desat_Pes = 'N'				
	order by 1

else if @ID_PD = 1 or @ID_PD = 2
	SELECT  
		PS.Apelido dados, 
		PS.Cd_Pes, 
		PS.Nome_Raz_Soc, 
		PS.Num_CPF_CNPJ,
		B.Nome_BDP_Produto
	FROM  dbo.Pessoa PS with (nolock)
		JOIN dbo.Campo_Pessoa PL with (nolock) ON PL.Cd_Pes = PS.Cd_Pes and PL.Id_Campo = 17
		join BDP_Produto B on B.ID_PD = PL.Campo_Dados	 
	where 
		PS.Desat_Pes = 'N'
		and (B.ID_PD = @ID_PD or ID_PD = 3)
		
	order by 1
	
else
	select '' dados
GO
