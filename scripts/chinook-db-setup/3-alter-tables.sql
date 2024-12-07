-- Executar script abaixo conectado numa sessão com user "chinook" e service name "XEpdb1"

/*******************************************************************************
   Create Primary Key Unique Indexes
********************************************************************************/

/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE Album ADD CONSTRAINT FK_AlbumArtistId
    FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId)  ;

ALTER TABLE Customer ADD CONSTRAINT FK_CustomerSupportRepId
    FOREIGN KEY (SupportRepId) REFERENCES Employee (EmployeeId)  ;

ALTER TABLE Employee ADD CONSTRAINT FK_EmployeeReportsTo
    FOREIGN KEY (ReportsTo) REFERENCES Employee (EmployeeId)  ;

ALTER TABLE Invoice ADD CONSTRAINT FK_InvoiceCustomerId
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)  ;

ALTER TABLE InvoiceLine ADD CONSTRAINT FK_InvoiceLineInvoiceId
    FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId)  ;

ALTER TABLE InvoiceLine ADD CONSTRAINT FK_InvoiceLineTrackId
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId)  ;

ALTER TABLE PlaylistTrack ADD CONSTRAINT FK_PlaylistTrackPlaylistId
    FOREIGN KEY (PlaylistId) REFERENCES Playlist (PlaylistId)  ;

ALTER TABLE PlaylistTrack ADD CONSTRAINT FK_PlaylistTrackTrackId
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId)  ;

ALTER TABLE Track ADD CONSTRAINT FK_TrackAlbumId
    FOREIGN KEY (AlbumId) REFERENCES Album (AlbumId)  ;

ALTER TABLE Track ADD CONSTRAINT FK_TrackGenreId
    FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)  ;

ALTER TABLE Track ADD CONSTRAINT FK_TrackMediaTypeId
    FOREIGN KEY (MediaTypeId) REFERENCES MediaType (MediaTypeId)  ;