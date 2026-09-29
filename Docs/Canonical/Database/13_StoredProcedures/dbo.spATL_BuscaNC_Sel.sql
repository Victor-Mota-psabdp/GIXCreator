SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_BuscaNC_Sel  '%','%','%', 'WAIT TIME EXCEEDED  ANTICIPATE ADDITIONAL CHARGES','%'
--spATL_BuscaNC_Sel '%','%','%','%','%'

--spATL_BuscaNC_Sel '%','%','%','%','%'
--spATL_BuscaNC_Sel '%','ALL PARTIES (UNIVERSAL)','BL RETRIEVAL','VESSEL / VOYAGE # DISCREPANCY','DIVERGÊNCIA NA CARTA DE CRÉDITO'
--spATL_BuscaNC_Sel '%','ALL PARTIES (UNIVERSAL)','BL RETRIEVAL','%','%'

CREATE procedure [dbo].[spATL_BuscaNC_Sel](

@Cd_NC	varchar(40),
@Parte_Resp	varchar(50),
@Processo	varchar(50),
@Descricao_nC	varchar(150),
@Descricao_NC_PTG	varchar(1000)
)




as
if @Cd_NC = '' begin set @Cd_NC = '%' end
if @Parte_Resp = '' begin set @Parte_Resp = '%' end
if @Processo = '' begin set @Processo = '%' end
if @Descricao_nC = '' begin set @Descricao_nC = '%' end
if @Descricao_NC_PTG = '' begin set @Descricao_NC_PTG = '%' end

--print @Cd_NC	
--print @Parte_Resp	
--print @Processo	
--print @Descricao_nC	
--print @Descricao_NC_PTG
if @Cd_NC = '%' and @Parte_Resp = '%' and @Processo = '%' and @Descricao_nC = '%' and @Descricao_NC_PTG = '%' 
begin
	select Cd_NC, Parte_Resp, Processo, Descricao_nC,Descricao_NC_ENG, Descricao_NC_PTG from Tipo_NC_Cliente with(nolock)
	where Parte_Resp is not null
end

else
Begin
if @Cd_NC = '%'
	begin
		select Cd_NC, Parte_Resp, Processo, Descricao_nC,Descricao_NC_ENG, Descricao_NC_PTG from Tipo_NC_Cliente with(nolock)
		where Cd_NC like @Cd_NC and
		Parte_Resp like @Parte_Resp and
		Processo like @Processo and
		Descricao_nC_ENG like @Descricao_nC and
		Descricao_NC_PTG like @Descricao_NC_PTG and    Ativo = 'S'
	end
else
	begin
		select Cd_NC, Parte_Resp, Processo, Descricao_nC,Descricao_NC_ENG, Descricao_NC_PTG, Descricao_nC [Descricao] from Tipo_NC_Cliente with(nolock)
		where Cd_NC = @Cd_NC 
	end
end

GO
