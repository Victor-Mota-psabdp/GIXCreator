SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[fSchneider_scope]
(
	@job varchar(16)
)

RETURNS VarChar(4)

AS

	BEGIN

		Declare @StrRetorno varchar(4)

		DECLARE @Porto_origem VARCHAR(3)
		DECLARE @Planta_origem VARCHAR(3)
		DECLARE @Porto_destino VARCHAR(3)
		DECLARE @Planta_destino VARCHAR(3)


		set @StrRetorno = ''

		If substring(@job,1,1) = 'I' 
			Begin
				SELECT   
				@Porto_origem = Cd_Planta_Lim			--PlantaOrigem,  
				,@Planta_origem = Cd_Org_HIM			--PortoOrigem,  
				,@Porto_destino = Cd_Dst_HIM			--PortoDestino,  
				,@Planta_destino = Cd_DstFinal_LIM		--PlantaDestino  
				From    
				House_Imp_Mar  HOU (nolock)  
				inner join  LLP_Imp_Mar  LLP (nolock)   
					on HOU.Num_Proc_HIM = LLP.Num_Proc_Lim  
				where  HOU.Num_Proc_HIM = @job

				if @Porto_origem = @Planta_origem and @Porto_destino = @Planta_destino 
					SET @StrRetorno = 'P2P'
				else if @Porto_origem <> @Planta_origem and @Porto_destino <> @Planta_destino 
					SET @StrRetorno = 'D2D'
				else if @Porto_origem <> @Planta_origem and @Porto_destino = @Planta_destino 
					SET @StrRetorno = 'D2DP'
				else if @Porto_origem = @Planta_origem and @Porto_destino <> @Planta_destino 
					SET @StrRetorno = 'P2D'
			END
		else If substring(@job,1,1) = 'E' 
			Begin
				SELECT   
				@Porto_origem = Cd_Planta_Lem			--PlantaOrigem,  
				,@Planta_origem = Cd_Org_HEM			--PortoOrigem,  
				,@Porto_destino = Cd_Dst_HEM			--PortoDestino,  
				,@Planta_destino = Cd_DstFinal_LEM		--PlantaDestino  
				From    
				House_Exp_Mar  HOU (nolock)  
				inner join  LLP_Exp_Mar  LLP (nolock)   
					on HOU.Num_Proc_HEM = LLP.Num_Proc_LEm  
				where  HOU.Num_Proc_HEM = @job

				if @Porto_origem = @Planta_origem and @Porto_destino = @Planta_destino 
					SET @StrRetorno = 'P2P'
				else if @Porto_origem <> @Planta_origem and @Porto_destino <> @Planta_destino 
					SET @StrRetorno = 'D2D'
				else if @Porto_origem <> @Planta_origem and @Porto_destino = @Planta_destino 
					SET @StrRetorno = 'D2DP'
				else if @Porto_origem = @Planta_origem and @Porto_destino <> @Planta_destino 
					SET @StrRetorno = 'P2D'
			END







		Return @StrRetorno

	END


















GO
