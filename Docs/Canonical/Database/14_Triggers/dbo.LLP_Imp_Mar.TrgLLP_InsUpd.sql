SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgLLP_InsUpd] ON [dbo].[LLP_Imp_Mar] For Insert,Update 

AS 

BEGIN

	
	Declare @ETAAnterior Datetime
	Declare @ETANovo Datetime
	Declare @ETDAnterior Datetime
	Declare @ETDNovo Datetime
	Declare @ATANovo Datetime	
	Declare @ATAAntigo Datetime	
	Declare @Num_PRoc	Varchar(16)
	Declare @MSG Varchar(400)
	Declare @ETAAddDay datetime
	Declare @ATAAddDay datetime
	Declare @QtyDays int

-- Coletando campos antigos
	select @ETAAnterior=eta_lim,@ETDAnterior=ETD_LIM,@ATAAntigo=ATA_LIM from deleted
-- Coletando campos Novos
	select @ETANovo=eta_lim,@ETDNovo=ETD_LIM,@ATANovo=ATA_LIM,@Num_proc=Num_proc_LIM from inserted
	

	If  substring(@Num_PRoc,3,3) = 'CSR'
		Begin
			if @ATANovo <> isnull(@ATAAntigo,0)
				Begin
					set @QtyDays = (select (Case When Cd_DstFinal_Lim in ('ITJ','IOA','NVT','URG','VCP','GRU') then 7 else Case When Cd_DstFinal_Lim ='GIG' then 10 else 0 end end)  from LLP_Imp_Mar with(nolock) where Num_Proc_Lim = @Num_PRoc )
					if @QtyDays <>0
						Begin
							set @ATAAddDay = (select dateadd(day,@QtyDays,@ATANovo))
							set @MSG= ('Confirmação de chegada e aguardando analise do MAPA. ATA: ' + convert(varchar(10),@ATANovo,105) +  space(10) + 'Historic created by ATL System')
							exec spHistG_InsUPD @Num_Proc,Null,Null,'ATA',@MSG,'01-01-2010',@ATAAddDay,'ATL System','S','U',Null
						End
				End
				
			if isnull(@ETAAnterior,0) <> @ETANovo 
				Begin
					set @QtyDays = (select (Case When Cd_DstFinal_Lim in ('ITJ','IOA','NVT','URG','VCP','GRU') then 7 else Case When Cd_DstFinal_Lim ='GIG' then 10 else 0 end end)  from LLP_Imp_Mar with(nolock) where Num_Proc_Lim = @Num_PRoc )
					if @QtyDays <>0
						Begin
							set @ETAAddDay = (select dateadd(day,@QtyDays,@ETANovo))
							set @MSG= ('Aguardando confirmação de chegada. ETA: ' + convert(varchar(10),@ETANovo,105) +  space(10) + 'Historic created by ATL System')
							exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA',@MSG,'01-01-2010',@ETAAddDay,'ATL System','S','U',Null
						End						
				End	
		End	
		
		
		if @ATANovo <> isnull(@ATAAntigo,0)
			BEGIN
				-- ATA + 08 Urgente "SIM" 
				-- ATA + 10 Urgente " Não"
				Declare @GR_Previsto_Date	datetime
				Declare @GR_Previsto_QtyDays int
				Declare @GR_Previsto_Date_Varchar	varchar(10)
				
				set @GR_Previsto_QtyDays =(select (case isnull(dbo.fBusca_CampoCliente(@Num_Proc,36),'N') when '1' then 8 
					when '2' then 10
				 else 10  end))
				--set @GR_Previsto_Date = (select dateadd(day,@GR_Previsto_QtyDays,@ATANovo))
				set @GR_Previsto_Date_Varchar = convert(varchar(10),(select dateadd(day,@GR_Previsto_QtyDays,@ATANovo)),105)
				exec spATL_CamposAdicionais_InsUpd @Num_Proc,'GR previsto',@GR_Previsto_Date_Varchar, 'ATL'
				
				set @MSG= ('GR Previsto alterado pelo ATA: ' + @GR_Previsto_Date_Varchar +  space(10) + 'Historic created by ATL System')
				exec spHistG_InsUPD @Num_Proc,Null,Null,'ATA',@MSG,'01-01-2010',null,'ATL System','N','S',Null
			END	
	
	
END


GO
ALTER TABLE [dbo].[LLP_Imp_Mar] ENABLE TRIGGER [TrgLLP_InsUpd]
GO
