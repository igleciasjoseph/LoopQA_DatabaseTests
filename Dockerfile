# Use a Node.js image - i had to specify platform in order for this to work due to mmy M1 mac
FROM --platform=linux/amd64 node:14

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    POSTGRES_USER=testuser \
    POSTGRES_PASSWORD=password \
    POSTGRES_DB=testdb

# Install PostgreSQL and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql postgresql-contrib && \
    rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL authentication
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/11/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf

# Start PostgreSQL, create the database, user, and decode and execute the Base64 SQL commands
RUN service postgresql start && \
    su - postgres -c "psql -c 'CREATE DATABASE testdb;'" && \
    su - postgres -c "psql -c \"CREATE USER testuser WITH PASSWORD 'password';\"" && \
    su - postgres -c "psql -c 'GRANT ALL PRIVILEGES ON DATABASE testdb TO testuser;'" && \
    echo "LS0gc2V0dXBfZGIuc3FsCgotLSBFbmFibGUgVVVJRCBleHRlbnNpb24gZm9yIHVuaXF1ZSBpZGVudGlmaWVycwpDUkVBVEUgRVhURU5TSU9OIElGIE5PVCBFWElTVFMgInV1aWQtb3NzcCI7CgotLSBDcmVhdGUgZW51bSBmb3IgdXNlciBzdGF0dXMKQ1JFQVRFIFRZUEUgdXNlcl9zdGF0dXMgQVMgRU5VTSAoJ2FjdGl2ZScsICdpbmFjdGl2ZScsICdzdXNwZW5kZWQnLCAnZGVsZXRlZCcpOwoKLS0gVXNlcnMgdGFibGUgd2l0aCBjb21wcmVoZW5zaXZlIHVzZXIgaW5mb3JtYXRpb24KQ1JFQVRFIFRBQkxFIHVzZXJzICgKICAgIGlkIFVVSUQgUFJJTUFSWSBLRVkgREVGQVVMVCB1dWlkX2dlbmVyYXRlX3Y0KCksCiAgICBlbWFpbCBWQVJDSEFSKDI1NSkgTk9UIE5VTEwgVU5JUVVFLAogICAgdXNlcm5hbWUgVkFSQ0hBUig1MCkgTk9UIE5VTEwgVU5JUVVFLAogICAgcGFzc3dvcmRfaGFzaCBWQVJDSEFSKDI1NSkgTk9UIE5VTEwsCiAgICBmaXJzdF9uYW1lIFZBUkNIQVIoNTApIE5PVCBOVUxMLAogICAgbGFzdF9uYW1lIFZBUkNIQVIoNTApIE5PVCBOVUxMLAogICAgZGF0ZV9vZl9iaXJ0aCBEQVRFIE5PVCBOVUxMLAogICAgcGhvbmVfbnVtYmVyIFZBUkNIQVIoMjApLAogICAgc3RhdHVzIHVzZXJfc3RhdHVzIERFRkFVTFQgJ2FjdGl2ZScsCiAgICBmYWlsZWRfbG9naW5fYXR0ZW1wdHMgSU5UIERFRkFVTFQgMCwKICAgIGxhc3RfbG9naW5fYXQgVElNRVNUQU1QIFdJVEggVElNRSBaT05FLAogICAgY3JlYXRlZF9hdCBUSU1FU1RBTVAgV0lUSCBUSU1FIFpPTkUgREVGQVVMVCBDVVJSRU5UX1RJTUVTVEFNUCwKICAgIHVwZGF0ZWRfYXQgVElNRVNUQU1QIFdJVEggVElNRSBaT05FIERFRkFVTFQgQ1VSUkVOVF9USU1FU1RBTVAsCiAgICBDT05TVFJBSU5UIGFnZV9jaGVjayBDSEVDSyAoZGF0ZV9vZl9iaXJ0aCA8PSBDVVJSRU5UX0RBVEUgLSBJTlRFUlZBTCAnMTMgeWVhcnMnKQopOwoKLS0gQ3JlYXRlIGluZGV4IGZvciBjb21tb24gcXVlcmllcwpDUkVBVEUgSU5ERVggaWR4X3VzZXJzX2VtYWlsIE9OIHVzZXJzKGVtYWlsKTsKQ1JFQVRFIElOREVYIGlkeF91c2Vyc191c2VybmFtZSBPTiB1c2Vycyh1c2VybmFtZSk7CkNSRUFURSBJTkRFWCBpZHhfdXNlcnNfc3RhdHVzIE9OIHVzZXJzKHN0YXR1cyk7CgotLSBBdWRpdCBsb2cgdGFibGUgdG8gdHJhY2sgaW1wb3J0YW50IGNoYW5nZXMKQ1JFQVRFIFRBQkxFIHVzZXJfYXVkaXRfbG9ncyAoCiAgICBpZCBVVUlEIFBSSU1BUlkgS0VZIERFRkFVTFQgdXVpZF9nZW5lcmF0ZV92NCgpLAogICAgdXNlcl9pZCBVVUlEIE5PVCBOVUxMIFJFRkVSRU5DRVMgdXNlcnMoaWQpLAogICAgYWN0aW9uIFZBUkNIQVIoNTApIE5PVCBOVUxMLAogICAgb2xkX3ZhbHVlIEpTT05CLAogICAgbmV3X3ZhbHVlIEpTT05CLAogICAgaXBfYWRkcmVzcyBJTkVULAogICAgY3JlYXRlZF9hdCBUSU1FU1RBTVAgV0lUSCBUSU1FIFpPTkUgREVGQVVMVCBDVVJSRU5UX1RJTUVTVEFNUCwKICAgIENPTlNUUkFJTlQgdmFsaWRfYWN0aW9uIENIRUNLIChhY3Rpb24gSU4gKCdjcmVhdGUnLCAndXBkYXRlJywgJ2RlbGV0ZScsICdsb2dpbicsICdsb2dvdXQnLCAncGFzc3dvcmRfY2hhbmdlJykpCik7CgotLSBGdW5jdGlvbiB0byB1cGRhdGUgdGhlIHVwZGF0ZWRfYXQgdGltZXN0YW1wCkNSRUFURSBPUiBSRVBMQUNFIEZVTkNUSU9OIHVwZGF0ZV91cGRhdGVkX2F0X2NvbHVtbigpClJFVFVSTlMgVFJJR0dFUiBBUyAkJApCRUdJTgogICAgTkVXLnVwZGF0ZWRfYXQgPSBDVVJSRU5UX1RJTUVTVEFNUDsKICAgIFJFVFVSTiBORVc7CkVORDsKJCQgTEFOR1VBR0UgcGxwZ3NxbDsKCi0tIFRyaWdnZXIgdG8gYXV0b21hdGljYWxseSB1cGRhdGUgdXBkYXRlZF9hdApDUkVBVEUgVFJJR0dFUiB1cGRhdGVfdXNlcnNfdGltZXN0YW1wCiAgICBCRUZPUkUgVVBEQVRFIE9OIHVzZXJzCiAgICBGT1IgRUFDSCBST1cKICAgIEVYRUNVVEUgRlVOQ1RJT04gdXBkYXRlX3VwZGF0ZWRfYXRfY29sdW1uKCk7CgotLSBGdW5jdGlvbiB0byBsb2cgdXNlciBjaGFuZ2VzCkNSRUFURSBPUiBSRVBMQUNFIEZVTkNUSU9OIGxvZ191c2VyX2NoYW5nZXMoKQpSRVRVUk5TIFRSSUdHRVIgQVMgJCQKQkVHSU4KICAgIElGIFRHX09QID0gJ0lOU0VSVCcgVEhFTgogICAgICAgIElOU0VSVCBJTlRPIHVzZXJfYXVkaXRfbG9ncyAodXNlcl9pZCwgYWN0aW9uLCBuZXdfdmFsdWUpCiAgICAgICAgVkFMVUVTIChORVcuaWQsICdjcmVhdGUnLCByb3dfdG9fanNvbihORVcpOjpqc29uYik7CiAgICBFTFNJRiBUR19PUCA9ICdVUERBVEUnIFRIRU4KICAgICAgICBJTlNFUlQgSU5UTyB1c2VyX2F1ZGl0X2xvZ3MgKHVzZXJfaWQsIGFjdGlvbiwgb2xkX3ZhbHVlLCBuZXdfdmFsdWUpCiAgICAgICAgVkFMVUVTIChORVcuaWQsICd1cGRhdGUnLCByb3dfdG9fanNvbihPTEQpOjpqc29uYiwgcm93X3RvX2pzb24oTkVXKTo6anNvbmIpOwogICAgRUxTSUYgVEdfT1AgPSAnREVMRVRFJyBUSEVOCiAgICAgICAgSU5TRVJUIElOVE8gdXNlcl9hdWRpdF9sb2dzICh1c2VyX2lkLCBhY3Rpb24sIG9sZF92YWx1ZSkKICAgICAgICBWQUxVRVMgKE9MRC5pZCwgJ2RlbGV0ZScsIHJvd190b19qc29uKE9MRCk6Ompzb25iKTsKICAgIEVORCBJRjsKICAgIFJFVFVSTiBOVUxMOwpFTkQ7CiQkIExBTkdVQUdFIHBscGdzcWw7CgotLSBUcmlnZ2VyIGZvciBhdWRpdCBsb2dnaW5nCkNSRUFURSBUUklHR0VSIHVzZXJfYXVkaXRfdHJpZ2dlcgogICAgQUZURVIgSU5TRVJUIE9SIFVQREFURSBPUiBERUxFVEUgT04gdXNlcnMKICAgIEZPUiBFQUNIIFJPVwogICAgRVhFQ1VURSBGVU5DVElPTiBsb2dfdXNlcl9jaGFuZ2VzKCk7CgotLSBBZGQgdGhpcyBiZWZvcmUgdGhlIG90aGVyIHRyaWdnZXJzCkNSRUFURSBPUiBSRVBMQUNFIEZVTkNUSU9OIHZhbGlkYXRlX3VzZXJfZGF0YSgpClJFVFVSTlMgVFJJR0dFUiBBUyAkJApCRUdJTgogICAgLS0gT2JzY3VyZSB2YWxpZGF0aW9uIHRoYXQgY2hlY2tzIGZvciBwYXNzd29yZF9oYXNoIGJ1dCBnaXZlcyBhIGNyeXB0aWMgZXJyb3IKICAgIElGIE5FVy5wYXNzd29yZF9oYXNoIElTIE5VTEwgT1IgTkVXLnBhc3N3b3JkX2hhc2ggPSAnJyBUSEVOCiAgICAgICAgUkFJU0UgRVhDRVBUSU9OICdVc2VyIHZhbGlkYXRpb24gZmFpbGVkOiBzZWN1cml0eSByZXF1aXJlbWVudHMgbm90IG1ldCAoY29kZTogVVNSLTEwMiknOwogICAgRU5EIElGOwogICAgUkVUVVJOIE5FVzsKRU5EOwokJCBMQU5HVUFHRSBwbHBnc3FsOwoKQ1JFQVRFIFRSSUdHRVIgdmFsaWRhdGVfdXNlcl90cmlnZ2VyCiAgICBCRUZPUkUgSU5TRVJUIE9OIHVzZXJzCiAgICBGT1IgRUFDSCBST1cKICAgIEVYRUNVVEUgRlVOQ1RJT04gdmFsaWRhdGVfdXNlcl9kYXRhKCk7CgotLSBJbnNlcnQgc2FtcGxlIGRhdGEKSU5TRVJUIElOVE8gdXNlcnMgKAogICAgZW1haWwsCiAgICB1c2VybmFtZSwKICAgIHBhc3N3b3JkX2hhc2gsCiAgICBmaXJzdF9uYW1lLAogICAgbGFzdF9uYW1lLAogICAgZGF0ZV9vZl9iaXJ0aCwKICAgIHBob25lX251bWJlcgopIFZBTFVFUyAoCiAgICAnam9obi5kb2VAZXhhbXBsZS5jb20nLAogICAgJ2pvaG5kb2UnLAogICAgJyQyYSQxMiRMUXYzYzF5cUJXVkh4a2QwTEhBa0NPWXo2VHR4TVFKcWhOOC9MZXdkQlBqNEovSFMuaTc3aScsIC0tIGhhc2hlZCAncGFzc3dvcmQxMjMnCiAgICAnSm9obicsCiAgICAnRG9lJywKICAgICcxOTkwLTAxLTE1JywKICAgICcrMS01NTUtMTIzLTQ1NjcnCik7CgotLSBHcmFudCBwZXJtaXNzaW9ucyB0byB0ZXN0dXNlcgpHUkFOVCBBTEwgUFJJVklMRUdFUyBPTiBBTEwgVEFCTEVTIElOIFNDSEVNQSBwdWJsaWMgVE8gdGVzdHVzZXI7CkdSQU5UIEFMTCBQUklWSUxFR0VTIE9OIEFMTCBTRVFVRU5DRVMgSU4gU0NIRU1BIHB1YmxpYyBUTyB0ZXN0dXNlcjsKR1JBTlQgVVNBR0UgT04gU0NIRU1BIHB1YmxpYyBUTyB0ZXN0dXNlcjsKR1JBTlQgRVhFQ1VURSBPTiBBTEwgRlVOQ1RJT05TIElOIFNDSEVNQSBwdWJsaWMgVE8gdGVzdHVzZXI7CkdSQU5UIFVTQUdFIE9OIFRZUEUgdXNlcl9zdGF0dXMgVE8gdGVzdHVzZXI7CgotLSBNYWtlIHRlc3R1c2VyIHRoZSBvd25lciBvZiB0aGUgdGFibGVzIGFuZCByZWxhdGVkIG9iamVjdHMKQUxURVIgVEFCTEUgdXNlcnMgT1dORVIgVE8gdGVzdHVzZXI7CkFMVEVSIFRBQkxFIHVzZXJfYXVkaXRfbG9ncyBPV05FUiBUTyB0ZXN0dXNlcjsKQUxURVIgRlVOQ1RJT04gdXBkYXRlX3VwZGF0ZWRfYXRfY29sdW1uKCkgT1dORVIgVE8gdGVzdHVzZXI7CkFMVEVSIEZVTkNUSU9OIGxvZ191c2VyX2NoYW5nZXMoKSBPV05FUiBUTyB0ZXN0dXNlcjsK" | \
    base64 -d | \
    su - postgres -c "psql -d testdb -f -" && \
    service postgresql stop

# Set up the working directory for the app
WORKDIR /app
COPY . .

# Install Node.js dependencies
RUN npm install

# Run the test when the container starts
CMD ["sh", "./run_test.sh"]
