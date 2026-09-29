SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE           procedure spVendasAgrup_Rel 
			@Vendedor Varchar(20),
			@DataInicial VarChar(10),
			@Datafinal   VarChar(10)
as


SELECT
	nome_usuario,Apelido,org.nome_local Origem, dst.nome_local Destino, 
	sum(DBO.FCEMBARQUES(@DataInicial,@DataFinal,isnull(cd_pes_b,VF.cd_pes),cd_org,cd_dst,cd_prop)) Embarques,
	sum(dbo.spVendas_Receita(@DataInicial,@DataFinal,isnull(cd_pes_b,VF.cd_pes),cd_org,cd_dst,cd_prop)) Receita,Dt_Fech

FROM 
	vendas_fechamento VF
	Join usuario US on cd_vendedor=cd_usuario
	Left Join Relacao RL on VF.cd_pes=cd_pes_a and cd_tp_rel='GPO'
	Join Pessoa pp on pp.cd_pes=VF.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst

WHERE 
	Nome_Usuario like @vendedor and us.cd_usuario not in ('COM')
	and convert(datetime,dt_fech,105)<=@datafinal

Group by
	nome_usuario,Apelido,org.nome_local,dst.nome_local, Dt_Fech







GO
