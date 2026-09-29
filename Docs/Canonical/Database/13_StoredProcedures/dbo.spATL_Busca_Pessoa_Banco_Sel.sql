SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Busca_Pessoa_Banco_Sel]-- 'P000027175',''
(
	@Cd_Pes varchar(10),
	@Apelido varchar(60)
)
as
	if @Apelido <> ''
		Begin
			Set @Cd_Pes = (select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)			
		End

select 
		'Banco: ' + T.Nome_Full_Banco +	'|' +
		'Codigo Banco: ' + B.cd_banco +	'|' +
		'Codigo Agencia: ' + B.cd_agencia +	'|' +
		'Conta Corrente: ' + B.Conta_corrente +	'|' +
		(Case when cd_tp_grupo = 'CPF' then 'CPF' else 'CNPJ' end) + ':' +  Num_CPF_CNPJ [Dado]
	from [dbo].[Pessoa_Banco]B With(nolock)
		 join Tipo_banco T With(nolock) on T.Id_tp_banco = B.Id_tp_banco
		join Pessoa P With(nolock) on P.cd_pes = B.cd_pes
	where B.Cd_Pes = @Cd_Pes

--Declare @Temp Table(
--	Dado varchar(50)
--)

--	--if @Apelido <> ''
--	--	Begin
--	--		Set @Cd_Pes = (select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)
--	--		PRINT @Cd_PEs
--	--	End
--	insert @Temp
--	Select Campo_Exibicao + ': ' + Campo_Dados from Campo_Pessoa CP
--	join Tipo_Campo_Pessoa TC on CP.Id_Campo = TC.Id_Campo
--	where CP.Cd_Pes = 'P000027175'and Descr_Campo in ('Banco','Codigo Banco','Codigo Agencia','Conta Corrente')
--	insert @Temp
--	select (Case when cd_tp_grupo = 'CPF' then 'CPF' else 'CNPJ' end) + ':' +  Num_CPF_CNPJ from Pessoa 
--	where Cd_Pes = 'P000027175'
	
	
--	select Dado from @Temp
	
	
	

	
	



GO
