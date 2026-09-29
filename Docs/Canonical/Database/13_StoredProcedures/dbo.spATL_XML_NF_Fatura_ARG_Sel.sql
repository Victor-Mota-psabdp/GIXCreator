SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_XML_NF_Fatura_ARG_Sel]'116027','I'

CREATE procedure [dbo].[spATL_XML_NF_Fatura_ARG_Sel]
(
	@NF	Varchar(10),
	@Codigo varchar(1)
)
as


	Declare @Obs varchar(2000)
	set @OBS = (select ' OBS: ' + replace(replace(obs,CHAR((13)) ,''),char(10),'') from Fatura_ARG with(nolock) where numero = @NF and codigo = @Codigo)


	select dbo.FRemoveAcentuacao(nome_tp_tx + ' ' + convert(varchar,Valor_ARP)) Descricao, dbo.FRemoveAcentuacao(@OBS) OBS from Fatura_ARG F with(nolock) 
		join Fatura_ARG_Det D with(nolock)  on D.id_fat = F.id_fat
		join tipo_taxa T with(nolock)  on T.cd_tp_tx = D.cd_tp_tx
		where 
			codigo = @Codigo 
			and numero = @NF
GO
